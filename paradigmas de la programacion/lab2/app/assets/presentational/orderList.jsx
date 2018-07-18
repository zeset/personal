import React from 'react';
import PropTypes from 'prop-types';
import OrderDetails from '../presentational/orderDetails';

{/*
Aqui se renderizan las ordenes que aparecen en el panel de perfil tanto se
consumidor como de proveedor. 
*/}

export default function OrderList(props) {
  let {orders, deliverOrder} = props;

  return(
    <div className="wrapper">
    { orders.map((ord, idx) => (
      <div key={idx} className="my-3 row">
        <div className="col-sm-8 offset-sm-2">
          <OrderDetails 
              store_name={ord.store_name} 
              order_amount={ord.order_amount}
              order_state={ord.status}
              order_id={ord.id}
              deliverOrder={deliverOrder}
              isProvider={localStorage.getItem('logged_type')}
          />
        </div>
      </div>
     ))
    }
    </div>
  );
}

OrderList.propTypes = {
  orders: PropTypes.array.isRequired,
  deliverOrder: PropTypes.func.isRequired
}