<?php echo $header; ?>

<?php echo $content_top; ?>

<div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
</div>

<header class="heading">
    <a href="index.php?route=account/products" style="display: inline-block;vertical-align: top;padding: 0 10px;text-align: center;"><img src="/image/products.png"><br>Товары</a>
    <a href="/index.php?route=account/order" style="display: inline-block;vertical-align: top;padding: 0 10px;text-align: center;"><img src="/image/orders.png"><br>Заказы</a>
    <a href="index.php?route=account/export" style="display: inline-block;vertical-align: top;padding: 0 10px;text-align: center;"><img src="/image/export.png"><br>Экспорт</a>
    <a href="index.php?route=account/product_return" style="display: inline-block;vertical-align: top;padding: 0 10px;text-align: center;"><img src="/image/returns.png"><br>Возвраты</a>
    <a href="index.php?route=account/account" style="display: inline-block;vertical-align: top;padding: 0 10px;text-align: center;"><img src="/image/help.png"><br>Помощь</a>
    <!--h1><?php echo $heading_title; ?></h1-->
</header>

<?php

	if ($column_left && $column_right) {
		$main = "col-sm-6 middle sideleft"; }
	else if ($column_left || $column_right) {
		$main = "col-sm-9";
		if($column_left) $main.=" sideleft"; else $main.= " sideright";
	}
	else { $main = "col-sm-12"; }

	?>
<form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="return" class="form" role="form">
<div class="row">

    <?php echo $column_left; ?>

    <section id="maincontent" class="<?php echo $main; ?>" role="main">

        <div class="mainborder">

            <?php if ($column_left || $column_right) { ?>
            <div id="toggle_sidebar"></div>
            <?php } ?>

            <table class="table table-bordered">

                <thead>
                <tr>
                    <td colspan="2">
                        <?php echo $text_order_detail; ?>
                    </td>
                </tr>
                </thead>

                <tbody>
                <tr>
                    <td style="width: 50%;">
                        <?php if ($invoice_no) { ?>
                        <b><?php echo $text_invoice_no; ?></b> <?php echo $invoice_no; ?><br />
                        <?php } ?>

                        <b><?php echo $text_order_id; ?></b> #<?php echo $order_id; ?><br />

                        <b><?php echo $text_date_added; ?></b> <?php echo $date_added; ?><br />

                        <!--<b><?php echo $text_post_date; ?>:</b> <?php echo $post_date; ?>-->
                    </td>
                    <td>
                        <b><?php echo $text_payment_method; ?></b> <?php echo $payment_method; ?>
                        <?php if ($shipping_method) { ?>
                        <br /><b><?php echo $text_shipping_method; ?></b> <?php echo $shipping_method; ?>
                        <?php } ?>

                        <?php if ($ttn) { ?>
                        <br /><b>ТТН:</b> <?php echo $ttn; ?>
                        <?php } ?>

                    </td>
                </tr>
                </tbody>

            </table>

            <table class="table table-bordered">
                <thead>
                <tr>
                    <td colspan="4">
                        <?php echo $text_shipping_address; ?>
                    </td>
                </tr>
                </thead>
                <tbody>
                <?php if ($error_region) { ?>
                <tr>
                <td><span class="error"><?php echo $error_region; ?></span></td>
                </tr>
                    <?php } ?>
                <tr>
                    <td style="width: 100%;">
                       <span style="color: red;">*</span> <input type="text" name="shipping_firstname" value="<?php echo $shipping_firstname; ?>"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <select name="shipping_zone" id="shipping_zone">
                                <option value="0">- выберите область -</option>
                            <?php foreach ($zones as $zone) { ?>
                            <?php if(!empty($zone['id_area'])){ ?>
                            <option value="<?php echo $zone['id_area'] ?>" ><?php echo $zone['name']; ?></option>
                            <?php } ?>
                            <?php } ?>
                        </select>

                        <div id="divregion">
                        <select name="shipping_city" id="shipping_city" disabled>
                            <option  value="0">- выберите город -</option>
                            <?php foreach ($regions as $region) { ?>
                           <option  value="<?php echo $region['id']?>"><?php echo $region['DescriptionRu']?></option>
                           <?php } ?>
                        </select>

                        </div>
                        <div id="divcity">
                        <select name="payment_address_1" id="payment_address_1">
                            <option  value="0">- выберите отдиления -</option>
                        </select>
                        </div>
                    </td>
                </tr>


                <tr>
                    <td style="width: 100%">
                        <span style="color: red;">*</span> <input type="text" name="telephone" value="<?php echo $telephone; ?>"></td>
                </tr>
                </tbody>
            </table>
            <?php if($sum_ > 0){ ?>
            <div style="text-align: right;font-size: 16px;"><b>Сумма наложки:</b> <?php echo (float)$sum_; ?></div>
            <?php } ?>
            <table class="table table-bordered table-adjust">

                <thead>
                <tr>
                    <td><?php echo "Фото"?></td>
                    <td><?php echo $column_name; ?></td>
                    <td><?php echo $column_model; ?></td>
                    <td><?php echo $column_quantity; ?></td>
                    <td><?php echo $column_price; ?></td>
                    <td><?php echo $column_total; ?></td>
                </tr>
                </thead>

                <tbody>

                <?php foreach ($products as $product) { ?>

                <tr>
                <tr>
                    <?php if (!empty($product['image'])) { ?>
                    <td style="text-align: center"><img src="<?php echo "/image/". $product['image'] ;?>" width="100" height="100"></td>
                    <?php } else { ?>
                    <td></td>
                    <?php } ?>

                    <td>
                        <b><?php echo $product['name']; ?></b>

                        <?php foreach ($product['option'] as $option) { ?>
                        <br />&nbsp;
                        <small> - <?php echo $option['name']; ?>: <?php echo $option['value']; ?></small>
                        <?php } ?>
                        <!--br />
                        <small>
                            <a href="<?php echo $product['return']; ?>" class="" title="<?php echo $button_return; ?>" ><?php echo $button_return; ?>  &rarr;</a>
                        </small-->
                    </td>
                    <td><?php echo $product['model']; ?></td>
                    <td class="right"><?php echo $product['quantity']; ?></td>
                    <td class="right"><?php echo $product['price']; ?></td>
                    <td class="right"><?php echo $product['total']; ?></td>
                </tr>

                <?php } ?>

                <?php foreach ($vouchers as $voucher) { ?>

                <tr>
                    <td><?php echo $voucher['description']; ?></td>
                    <td></td>
                    <td class="right">1</td>
                    <td class="right"><?php echo $voucher['amount']; ?></td>
                    <td class="right"><?php echo $voucher['amount']; ?></td>
                </tr>
                <?php } ?>

                </tbody>

                <tfoot>
                <?php foreach ($totals as $total) { ?>

                <tr>
                    <td></td>
                    <td colspan="4" class="right"><b><?php echo $total['title']; ?>:</b></td>
                    <td class="right"><?php echo $total['text']; ?></td>
                </tr>
                <?php } ?>
                </tfoot>

            </table>


            <div class="form-actions" style="text-align: center">
                <a href="<?php echo $back; ?>" class="button button-default"><?php echo $button_back; ?></a>
                <input type="hidden" name="order_id" value="<?php echo $order_id?>"/>
                <input type="submit" value="<?php echo $button_continue; ?>" class="button button-default button-inverse" />
            </div>
         </form>
    </section> <!-- #maincontent -->

    <?php echo $column_right; ?>

</div> <!-- .row -->

<?php echo $content_bottom; ?>
<style>
    #divregion, #divcity {
        display: none;
        margin-top: 15px;
    }
</style>
<?php echo $footer; ?>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script>
    $(document).ready(function () {
        $("#shipping_zone").change(function () {
            var zone = parseInt($("#shipping_zone").val());
            console.log(zone);
            getCodeNovaposhtaCities(zone);
        });
    });
function getCodeNovaposhtaCities(zone){
var city = $("#shipping_city");
    if(zone > 0){
        $("#divregion").fadeIn("slow");
        city.attr("disabled", false);
        city.load(
                "catalog/,model/account/order.php",
                {zone: zone},

        );
    }
}
</script>



