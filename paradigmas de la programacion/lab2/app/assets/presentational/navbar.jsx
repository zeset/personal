import React from 'react';
import PropTypes from 'prop-types';
import '../static/navbar.css';

{/* Aqui es donde se renderiza la barra de navegacion, que cambie segun el 
  estado de la sesion del usuario(si esta loggeado o no)
*/}

export function Navbar(props) {
  let { logged } = props;

    if (logged == undefined) {
      return (
        <nav className="navbar navbar-expand-md navbar-dark">
          <a className="navbar-brand" href="/">Deliveru</a>
          <ul className="ml-auto navbar-nav">
            <li className="nav-item"><a className="nav-link" 
                href="/signup">Registrate</a>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="/login">Iniciá Sesión</a>
            </li>
          </ul>
        </nav>
      );
    } else {
      return (
        <nav className="navbar navbar-expand-md navbar-dark">
          <a className="navbar-brand" href="/">Deliveru</a>
          <ul className="ml-auto navbar-nav">
            <li className="nav-item"><a className="nav-link"
                href="/profile">Perfil</a>
            </li>
            <li className="nav-item"><a className="nav-link"
                href="/logout">Cerrá Sesión</a>
            </li>
          </ul>
        </nav>
      );
    }
}

Navbar.PropTypes = {
  logged: PropTypes.string.isRequired
}