import React from 'react';
import PropTypes from 'prop-types';
import DeliverButton from '../presentational/deliverButton';

{/* Aqui es donde se renderiza algunos de los datos de la orders
*/}

export default function OrderDetails(props) {
  let { 
    store_name,
    deliverOrder, 
    order_state, 
    isProvider, 
    order_amount,
    order_id
  } = props;

  return (
    <div className="w-100 card">
      <h4 className="card-header">
        <strong> {store_name} </strong> 
        $ {order_amount}
        <span className="float-right">
          <span className="badge badge-primary">
          {order_state}
          </span>
        </span>
      </h4>

      <div className="card-body">
        <DeliverButton isProvider={isProvider == 'providers'} 
          deliverOrder={deliverOrder} 
          order_status={order_state} 
          order_id={order_id}
        />
      </div>
    </div>
  );
}

OrderDetails.PropTypes = {
  store_name: PropTypes.string.isRequired,
  deliverOrder: PropTypes.func.isRequired,
  order_state: PropTypes.string.isRequired,
  isProvider: PropTypes.string.isRequired, 
  order_amount: PropTypes.number.isRequired,
  order_id: PropTypes.number.isRequired
}