import React from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

{/* Aqui es donde se renderiza el listado de items en em perfil de proveedor
*/}

export default function ItemList(props) {
  let { isProvider, 
        items, 
        handleChangeName, 
        handleChangePrice, 
        itemPost, 
        itemRemove, 
        price, 
        itemName 
  } = props;

  if (isProvider) {
    return (
        <div className="wrapper">
            <h1 className="display-4 text-center my-3">Menu</h1>
            <ul>
              {items.map((item, idx) => (
                <li key={idx}>
                  <div>
                    <span>
                      <button onClick={itemRemove} value={item.id}>
                      x
                      </button>
                    </span>
                    <span>{item.name}: </span>
                    <span>$ {item.price}</span>
                  </div>
                </li> 
              ))}
            </ul>
            <form className="">
              <h2 className="form-signin-heading">
              Registra un nuevo item 
              </h2>
              Nombre del item
              <span>
              <input type="text" value={itemName} 
                onChange={handleChangeName}
                id="inputPasswordProvider" className="form-control" 
                placeholder="Password" required 
              />
              </span>
              Precio del item
              <span>
              <input type="number" id="max_delivery_distance-provider" 
                value={price} 
                onChange={handleChangePrice}
              />
              </span>
              <span>
              <button className="item-add" type="button" 
              onClick={itemPost}>Registrar Item</button>
              </span>
            </form>

        </div>
    )
  } else {
    return (null)
  }
  
}

ItemList.PropTypes = {
  isProvider: PropTypes.bool.isRequired, 
  items: PropTypes.array.isRequired, 
  handleChangeName: PropTypes.func.isRequired, 
  handleChangePrice: PropTypes.func.isRequired, 
  itemPost: PropTypes.func.isRequired, 
  itemRemove: PropTypes.func.isRequired, 
  price: PropTypes.number.isRequired, 
  itemName: PropTypes.string.isRequired
}