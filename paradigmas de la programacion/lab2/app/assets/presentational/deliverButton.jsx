import React from 'react';
import PropTypes from 'prop-types';

{/*
Renderiza el boton que permite marcar las ordenes como entregadas en el panel 
de proveedor
*/}

export default function DeliverButton(props) {
  let {isProvider, order_status, deliverOrder, order_id} = props;

  if (isProvider && (order_status === 'payed')) {
    return(
      <div className="row">
        <div className="text-center col-sm-12">
          <button type="button" 
            className="btn btn-success" 
            onClick={props.deliverOrder}
            value ={order_id}>
            Pedido Enviado
          </button>
        </div>
      </div>
    );
  } else {
    return(null);
  }

}

DeliverButton.propTypes = {
  isProvider: PropTypes.bool.isRequired,
  order_status: PropTypes.string.isRequired,
  deliverOrder: PropTypes.func.isRequired,
  order_id: PropTypes.number
}