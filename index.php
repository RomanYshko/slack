<?php
class ControllerModuleCronNovaPoshta extends Controller {
    public function index() {

        if (isset($this->request->get['key']) && $this->request->get['key'] == $this->config->get('novaposhta_key_cron')) {                require_once(DIR_SYSTEM . 'helper/novaposhta.php');

            $novaposhta = new NovaPoshta($this->registry);

            $orders = $this->db->query("SELECT `o`.* FROM `" . DB_PREFIX . "order` as `o` WHERE `o`.`order_status_id` IN (" . implode(',', $this->config->get('novaposhta_tracking_statuses')) . ")AND `o`.`telephone` != '' AND `o`.`novaposhta_ei_number` != '' ORDER BY RAND() LIMIT 85")->rows;

            if ($orders) {
                $ei_numbers = array();
                //$telephone = array();

                foreach($orders as $k => $order){
                    $ei_numbers[] = $order['novaposhta_ei_number'];
                    //$telephone[] = $order['telephone'];
                    $orders[$order['novaposhta_ei_number']] = $order;
                    //$orders[$order['telephone']] = $order;

                    unset($orders[$k]);
                }


                $documents = $novaposhta->tracking($ei_numbers);




                if ($documents) {
                    $tracking_settings = $novaposhta->arrayKey($this->config->get('novaposhta_settings_tracking_statuses'), 'novaposhta');

                    foreach($documents as $document){
                        if ($document['Number'] || $document['telephone']) {
                            var_dump($document['Number']);
                            $set_arr = array();

                            var_dump($document['telephone']);

                            if($orders[$document['Number']]['ttn'] == ""){
                                $set_arr[] = "`ttn` = '" . $this->db->escape($orders[$document['Number']]['novaposhta_ei_number']) . "'";
                            }

                            /*if($orders[$document['Number']]['back_ttn'] == "" && trim($document['RedeliveryNum'])){
                                $set_arr[] = "`back_ttn` = '" . $this->db->escape($document['RedeliveryNum']) . "'";
                            }*/



                            if($orders[$document['Number']]['Sum_back'] == "" ){
                                $set_arr[] = "`Sum_back` = '" . $this->db->escape($document['RedeliverySum']) . "'";
                            }

                            print_r($orders[$document['Number']]);




                            if($orders[$document['Number']]['sum_delivery'] == "" ){
                                $set_arr[] = "`sum_delivery` = '" . $this->db->escape($document['DocumentCost']) . "'";
                            }



                            if($orders[$document['Number']]['sum_date'] == '0000-00-00' && trim($document['RecipientDateTime'])){
                                $set_arr[] = "`sum_date` = '" . $this->db->escape(date("Y-m-d", strtotime($document['RecipientDateTime']))) . "'";
                            }

                            if($orders[$document['Number']]['post_date'] == '0000-00-00' && trim($document['DateCreated'])){
                                $set_arr[] = "`post_date` = '" . $this->db->escape(date("Y-m-d", strtotime($document['DateCreated']))) . "'";
                            }

                            if(strtolower(trim($document['Status'])) != strtolower(trim($orders[$document['Number']]['ttn_status']))){
                                $set_arr[] = "`ttn_status` = '" . $this->db->escape($document['Status']) . "'";
                            }

                            if($set_arr){
                                $this->db->query("UPDATE `" . DB_PREFIX . "order` SET " . implode(', ', $set_arr) . " WHERE order_id = '" . (int)$orders[$document['Number']]['order_id'] . "'");
                                echo $orders[$document['Number']]['order_id'] . " OK\n\r<br>";
                            }
                        }
                    }
                }
            }

            $orders = $this->db->query("SELECT `o`.* FROM `" . DB_PREFIX . "order` as `o` WHERE `o`.`order_status_id` IN (" . implode(',', $this->config->get('novaposhta_tracking_statuses')) . ") AND `o`.`novaposhta_ei_number` != '' AND `o`.`ttn` != '' AND `o`.`sum_delivery` != '' AND `o`.`sum_date` = '0000-00-00' LIMIT 85")->rows;

            if ($orders) {
                $ei_numbers = array();

                foreach($orders as $k => $order){
                    $ei_numbers[] = $order['ttn'];
                    $orders[$order['ttn']] = $order;


                    unset($orders[$k]);
                }


                $documents = $novaposhta->tracking($ei_numbers);

                if ($documents) {
                    $tracking_settings = $novaposhta->arrayKey($this->config->get('novaposhta_settings_tracking_statuses'), 'novaposhta');

                    foreach($documents as $document){
                        if ($document['Number']) {
                            $set_arr = array();

                            if($orders[$document['Number']]['sum_date'] == '0000-00-00' && trim($document['RecipientDateTime'])){
                                $set_arr[] = "`sum_date` = '" . $this->db->escape(date("Y-m-d", strtotime($document['RecipientDateTime']))) . "'";
                            }





                            if($orders[$document['Number']]['sum_delivery'] == "" && trim($document['DocumentCost'])){
                                $set_arr[] = "`sum_delivery` = '" . $this->db->escape($document['DocumentCost']) . "'";
                            }





                            if($set_arr){
                                $this->db->query("UPDATE `" . DB_PREFIX . "order` SET " . implode(', ', $set_arr) . " WHERE order_id = '" . (int)$orders[$document['Number']]['order_id'] . "'");
                                echo $orders[$document['Number']]['order_id'] . " OK\n\r<br>";
                            }
                        }
                    }
                }
            }
        }
    }
}