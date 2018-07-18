import React from 'react';
import PropTypes from 'prop-types';

{/*
Aqui se renderizan los poveedores disponibles en la zona seleccionada
por el cliente.
*/}

export default function ProvidersList(props) {
  let {providers} = props;

  if (providers.length == 0) {
    return(
      <div className="container">
        <h3>Lo sentimos, no encontramos proveedores en tu zona.</h3>
      </div>
    );
  } else {
    return (
      <div className="container">
        <ul>
          { providers.map((prov, idx) => (
            <li key={idx} className={prov.id.toString()}>
              <a className="btn btn-primary" 
                href={"/menu?id=" + prov.id.toString()}>
                {prov.store_name}</a><br /><br />
            </li>
          ))}
        </ul>
      </div>
    );
  }
}

ProvidersList.PropTypes = {
  providers: PropTypes.array.isRequired,
}