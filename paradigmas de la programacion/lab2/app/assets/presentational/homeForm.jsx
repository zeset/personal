import React from 'react';
import PropTypes from 'prop-types';
import Main from '../containers/main';
import { Link } from 'react-router-dom';

{/* Renderiza las ubicaciones disponibles
  para que el cliente vea los proveedores disponibles de esa zona
*/}

export default function HomeForm(props) {
  let { handleChangeLocation, locations, chosenLocation } = props;

  return (
    <div className="body">
      <div>
        <h2 className="form-signin-heading">¿Que vas a comer hoy?</h2>
        <select value={chosenLocation} 
        onChange={handleChangeLocation}>
          <option value="">Selecciona una localidad</option>
          { locations.map((loc, idx) => (
          <option key={idx} value={loc.id}>{ loc.name }</option>  
          ))
          }
        </select>
        <Link to={
            chosenLocation == 0 || !isFinite(chosenLocation)
            ? "/delivery/?location" 
            : "/delivery/?location="+chosenLocation
        }>
          Buscar
        </Link>
      </div>
    </div>
  );
}


HomeForm.PropTypes = {
  handleChangeLocation: PropTypes.func.isRequired,
  locations: PropTypes.array.isRequired,
  chosenLocation: PropTypes.number.isRequired
}
