import React from 'react';
import axios from 'axios';
import HomeForm from '../presentational/homeForm';
import { Navbar } from '../presentational/navbar';

{/* Aqui es donde obtenemos las ubicaciones actualmente disponibles y 
  recopilamos la informacion del usuario desde homeForm
*/}

export default class Main extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      locations: [],
      chosenLocation: 0,
    };

    this.handleChangeLocation = this.handleChangeLocation.bind(this);
  }

  handleChangeLocation(event) {
    this.setState({chosenLocation: parseInt(event.target.value)});
  }

  componentDidMount() {

    if (localStorage.getItem('logged') == 'true') {
      if (localStorage.getItem('logged_type') == 'providers'){
        this.props.history.push("/profile");
      }
    } else {
      if (localStorage.getItem('logged_type') == 'providers'){
        this.props.history.push("/profile");
      } else {
        this.props.history.push("/");
      }
    }

    axios
      .get("/api/locations")
      .then(
        response => this.setState({locations: response.data})
      ).catch(
        error => {
          if (!error.response)
            alert(error);
          else if (error.response.data && error.response.status !== 404)
            alert(error.response.data);
          else
            alert(error.response.statusText);
        }
      );
  }

  render() {
    return (
      <div>
        <Navbar logged={localStorage.getItem("logged")}/>
        <HomeForm locations={this.state.locations}
                  chosenLocation={this.state.chosenLocation}
                  handleChangeLocation={this.handleChangeLocation}/>
      </div>
    );
  }
}