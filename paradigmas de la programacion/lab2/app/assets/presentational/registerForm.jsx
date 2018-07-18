import React from 'react';
import PropTypes from 'prop-types';

{/* Aqui es donde de renderiza el formulario de registro de un usuario,
que luego es utilizado por el container signup
*/}

export default function RegisterForm(props) {
  let { type, handleChange, handleSubmit, locations } = props;

  if (type == "consumers") {
    return (
      <div>
      <div className= "text-center">
        <button onClick={handleChange}
              name="type"
              value="providers"
              type="submit">
      Registrate como Proveedor</button>
      </div>
      <form onSubmit={handleSubmit} className="formcenter">
        <label>Email: </label>
        <input type="email"
               onChange={handleChange}
               className= "form-control"
               name="email"
        /><br />
        <label>Contraseña: </label>
        <input type="password"
               onChange={handleChange}
               className= "form-control"
               name="password"
        /><br />
        <label>Ubicación: </label>
        <select name="location" onChange={handleChange} 
        className="form-control">
          <option value={0} ></option>
          { locations.map((loc, idx) => (
            <option key={idx}
                    className={loc.id.toString()}
                    value={loc.id.toString()}>
          { loc.name }</option>
          ))
          }
        </select><br />
        <div className="text-center">
        <input type="submit" value="Enviar" className="btn btn-success"/>
        </div>
      </form>
      </div>
    );
  } else if (type == "providers") {
     return (
      <div>
      <div className= "text-center">
        <button onClick={handleChange}
                name="type"
                value="consumers"
                type="submit">
        Registrate como Consumidor</button>
      </div>
      <form onSubmit={handleSubmit} className="formcenter">
        <label>Nombre:</label>
        <input type="text"
               onChange={handleChange}
               className= "form-control"
               name="store_name"
        /><br />
        <label>Email:</label>
        <input type="email"
               onChange={handleChange}
               className= "form-control"
               name="email"
        /><br />
        <label>Contraseña:</label>
        <input type="password"
               onChange={handleChange}
               className= "form-control"
               name="password"
        /><br />
        <label>Rango:</label>
        <input type="number"
               inputMode="numeric"
               min={0}
               onChange={handleChange}
               className= "form-control"
               name="max_delivery_distance"
        /><br />
        <label>Ubicación:</label>
        <select name="location" onChange={handleChange} 
        className= "form-control">
          <option value={0} ></option>
          { locations.map((loc, idx) => (
            <option key={idx}
                    className={loc.id.toString()}
                    value={loc.id.toString()}>
          { loc.name }</option>
          ))
          }
        </select><br />
        <div className="text-center">
        <input type="submit" value="Enviar" className="btn btn-success"/>
        </div>
      </form>
      </div>
    );
  }
}

RegisterForm.PropTypes = {
  type: PropTypes.string.isRequired,
  handleChange: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  locations: PropTypes.array.isRequired,
}
