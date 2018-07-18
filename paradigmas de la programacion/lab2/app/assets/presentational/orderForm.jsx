import React from 'react';
import PropTypes from 'prop-types';

{/* Desde aca se renderiza el listado de items para que el usuario realize la 
orden, asi tambien como el formulario para que realize su pedido. Aqui tambien,
entre otras cosas, se calcula el monto total de la orden y los balances tanto
del consumer como del provider
*/}


export default function OrderForm(props) {
  let {items, orderDetails, amount} = props;

  if (items.length == 0) {
    return(
      <div className="body">
        <div className="wrapper" style={{marginLeft: '10px'}}>
          <h1 className="display-3 text-center mb-5">
            Este proveedor no tiene un menu disponible.
          </h1>
        </div>
      </div>
    );  
  } else {
    return(
      <div className="body">
        <div className="wrapper" style={{marginLeft: '10px'}}>
          <h1 className="display-3 text-center mb-5">
            Este es nuestro menu:</h1>
            <label>
              Elije la cantidad para cada item...
              <div name="item" >
                { props.items.map((item_i, idx) => (
                  <div key={idx} >
                    <li >{item_i.name}</li>
                    <label>
                      Cantidad: 
                      <input style={{marginLeft: '10px', marginRight: '10px'}}
                        type="number" name={idx} onChange={props.onChange}
                      />
                      Subtotal:${item_i.price * props.orderDetails[idx].amount}
                    </label>
                  </div>
                  ))
                }
              </div>     
              <p> Total: ${props.items
                          .map((item_i,idx) =>(
                            item_i.price * props.orderDetails[idx].amount))
                            .reduce((acc, curr) => (acc + curr), 0)} </p> 
              <input type="submit" value="¡Haz tu orden!"
                     onClick={props.placeOrder}/>
            </label>
        </div>
      </div>
      );
  }
  
}

OrderForm.propTypes = {
  orderDetails: PropTypes.array .isRequired,
  items: PropTypes.array.isRequired,
  amount: PropTypes.number,
  unChanged: PropTypes.func
}