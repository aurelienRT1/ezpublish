<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="no" lang="no">
{let pagedesign=fetch_alias(by_identifier,hash(attr_id,shop_package))}
<head>
{include uri="design:page_head.tpl" enable_glossary=false() enable_help=false()}

{*<link rel="stylesheet" type="text/css" href={$pagedesign.data_map.css.content|ezpackage(filepath,"cssfile")|ezroot} />*}

<style>
    @import url({"stylesheets/core.css"|ezdesign});
{*    @import url({$pagedesign.data_map.css.content|ezpackage(filepath,"cssfile")|ezroot}); *}
     @import url("/design/shop/stylesheets/shop-blue.css");
</style>

</head>

<body>

<div id="background">

    <div id="header">
        <div class="design">
        
           {let content=$pagedesign.data_map.image.content}
            <div id="logo">
                <a href={"/"|ezurl}><img src={$content[logo].full_path|ezroot} /></a>
            </div>
           {/let}
                  
        </div>
    </div>

    <div id="subheader">
        <div class="design">
       
        <div id="mainmenu">
            <div class="design">

                <h3 class="invisible">Main menu</h3>
                <ul>
                {let folder_list=fetch( content, list, hash( parent_node_id, 2, sort_by, array( array( priority ) ) ) )}
                {section name=Folder loop=$folder_list}
                    <li><a href={concat( "/content/view/full/", $Folder:item.node_id, "/" )|ezurl}>{$Folder:item.name|wash}</a></li>
                {/section}
                {/let}
                </ul>
            
            </div>
        </div>

        <div id="shoppingmenu">
             <ul>
                 {section show=$current_user.is_logged_in}
		 <li><a href={"/notification/settings"|ezurl}>notifications</a></li>
                 <li><a href={concat( '/content/edit/', $current_user.contentobject_id )|ezurl}>Edit account</a></li>
		 <li><a href={"/shop/basket/"|ezurl}>View basket</a></li>
		 <li><a href={"/user/logout"|ezurl}>logout</a></li>
		 {section-else}
		 <li><a href={"/user/login"|ezurl}>login</a></li>
                 {/section}
             </ul>
        </div>
        
        <div class="break"></div> {* This is needed for proper flow of floating objects *}
        
        </div>
    </div>

    <div id="submenu">
        <div class="design">
            <h2>Products</h2>  
            {let path=$module_result.path
                 node_id=$module_result.node_id}

              {section show=$module_result.path[1].node_id|ne(154)}
	         {set path=array(hash('node_id',2,'url','/content/view/full/2'),hash('node_id',154,'url','/content/view/full/154'))}
                 {set node_id=154}
              {/section}

            <h3 class="invisible">Sub menu</h3>
            <ul>
                {let mainMenu=treemenu($path,$node_id,array('folder','info_page'), 1, 10 )}
                    {section var=menu loop=$mainMenu}
                        {section show=$menu.item.is_selected}
                            <li class="level_{$menu.item.level}">
                               <div class="selected"> 
                               <a href={$$menu.item.url_alias|ezurl}>{$menu.item.text}</a>
                               </div>  
                             </li>
                        {section-else}
                            <li class="level_{$menu.item.level}">
                             <a href={$menu.item.url_alias|ezurl}>{$menu.item.text}</a>
                            </li>
                        {/section}
                   {/section}
                {/let}
            </ul>
            {/let}
        
        </div>
    </div>

    <div id="searchbox">
        <div class="design">
            <form action={"/content/search/"|ezurl} method="get">
                 <input class="searchtext" type="text" size="10" name="SearchText" id="Search" value="" />
                 <input class="searchbutton" name="SearchButton" type="submit" value="Search" />
            </form>
        </div>
    </div>

    <div id="submenu">
        <div class="design">
            <h2>Latest products</h2>  
            {let new_product_list=fetch( content, tree, hash( parent_node_id, 2,
                                                                    limit, 6, 
                                                                    sort_by, array( published, false() ),
                                                                    class_filter_type, include, 
                                                                    class_filter_array, array( 'product' ) ) )}
            <ul>
                   {section name=Product loop=$new_product_list}
                       <li>
                       <a href={$:item.url_alias|ezurl}>{$:item.name|wash}</a>
                       <div class="date">
                        ({$:item.object.published|l10n( shortdate )})
                       </div>  
                       </li>
                    {/section}
            </ul>


            {/let}
        </div>
    </div>
    <div id="cart">
        <div class="design">

            {let basket=fetch( shop, basket )
                 use_urlalias=ezini( 'URLTranslator', 'Translation' )|eq( 'enabled' )
                 basket_items=$basket.items}
            <h3>Shopping cart <a href={"/shop/basket"|ezurl}><img src={'arrow_right.gif'|ezimage} alt="Basket" width="12" height="12" /></a></h3>
            {section show=$basket_items}
            <ul>
                {section var=product loop=$basket_items sequence=array( odd, even )}
                    <li>
                    {$product.item.item_count} x <a href={cond( $use_urlalias, $product.item.item_object.contentobject.main_node.url_alias,
                                                                concat( "content/view/full/", $product.item.node_id ) )|ezurl}>{$product.item.object_name}</a>
                    </li>
                {/section}
            </ul>
            <div class="price">{$basket.total_inc_vat|l10n(currency)}</div>
            {section-else}
                0 items
            {/section}
            {/let}

        </div>
    </div>
    <div id="infobox">
        <div class="design">
            {let bestseller_list=false()}
            {switch match=$module_result.content_info.class_id}
                {case match=23}
                    {set bestseller_list=fetch( shop, best_sell_list, hash( top_parent_node_id, $DesignKeys:used.parent_node,
                                                          limit, 5 ) )}
                {/case}
	        {case match=1}
                    {switch match=$module_result.path[1].node_id}
		    {case match=154}
                        {set bestseller_list=fetch( shop, best_sell_list, hash( top_parent_node_id, $DesignKeys:used.node,
                                                          limit, 5 ) )}
                    {/case}
                    {case}
                        {set bestseller_list=fetch( shop, best_sell_list, hash( top_parent_node_id, 2,
                                                          limit, 5 ) )}
                    {/case}
		    {/switch}
                {/case}
                {case}
                    {set bestseller_list=fetch( shop, best_sell_list, hash( top_parent_node_id, 2,
                                                          limit, 5 ) )}
                {/case}
            {/switch}
            <h3>Best sellers</h3>
            <ul>
                   {section name=Products loop=$bestseller_list}
                       <li>
                       <a href={concat( 'content/view/full/', $Products:item.main_node_id )|ezurl}>{$Products:item.name|wash}</a> 
                       </li>
                    {/section}
            </ul>
            {/let}
        
               {let news_list=fetch( content, tree, hash( parent_node_id, 2,
                                                          limit, 5,
                                                          sort_by, array( published, false() ),
                                                          class_filter_type, include, 
                                                          class_filter_array, array( 2 ) ) )}
                                                          
            <h3>Latest news</h3>
            <ul>
                   {section name=News loop=$news_list}
                       <li>
                       <a href={concat( 'content/view/full/', $News:item.node_id )|ezurl}>{$News:item.name|wash}</a>
                       <div class="date">
                        ({$News:item.object.published|l10n( shortdate )})
                       </div>  
                       </li>
                    {/section}
            </ul>
               {/let}
        
        </div>
    </div>

    <div id="maincontent">
        <div class="design">
        
    <div id="path">
        <div class="design">

           <p>
           &gt;
           {section name=Path loop=$module_result.path }
               {section show=$Path:item.url}
                  <a href={$Path:item.url|ezurl}>{$Path:item.text|wash}</a>
               {section-else}
    	      {$Path:item.text|wash}
               {/section}
    
               {delimiter}
                 /
               {/delimiter}
            {/section}
           </p>

        </div>
    </div>
            {$module_result.content}
        
        </div>
    </div>

    <div id="footer">
        <div class="design">
        
            <address>
            Copyright &copy; <a href="http://ez.no">eZ systems as</a> 1999-2003
            <a href="http://ez.no/">Powered by eZ publish Content Management System</a>
            </address>
        
        </div>
    </div>

</div>

</body>
{/let}
</html>
