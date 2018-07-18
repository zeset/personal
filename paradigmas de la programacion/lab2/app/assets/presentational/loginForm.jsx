import React from 'react';
import PropTypes from 'prop-types';

{/* Aqui es donde se renderiza el formulario de login para el usuario
*/}

export default function LoginForm(props) {
  let { handleChange, handleSubmit } = props;

  return (
    <form className="formcenter" onSubmit={handleSubmit} >
      <label>Email:</label>
      <input type="text" name="email" className="form-control" 
      onChange={handleChange} />
      <br />
      <label>Contraseña:</label>
      <input type="password" name="password" className="form-control" 
      onChange={handleChange} /><br />
      <div className="text-center">
        <input type="submit" value="Enviar" className="btn btn-success"/>
      </div>
    </form>
  );
}

LoginForm.PropTypes = {
  handleChange: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
}