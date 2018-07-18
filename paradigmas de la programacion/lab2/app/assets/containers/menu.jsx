import React from 'react';
import queryString from 'query-string';
import axios from 'axios';
import OrderForm from '../presentational/orderForm';
import { Navbar } from '../presentational/navbar';


{/* Aqui se obtiene la informacion de los los menus y se realizan las ordenes. 
  Utilizamos llamadas a la API para obtener informacion tanto de los menus como 
  de los pedidos realizados para poder registrarlos.
*/}

export default class Menu extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      items: [],
      consumer: parseInt(localStorage.getItem('logged_id')),
      orderDetails:[],
      amount:0,
      ordId:0,
    }
    this.onChange = this.onChange.bind(this);
    this.placeOrder = this.placeOrder.bind(this);
  }

  onChange(element){
    var orderDetailsCopy = this.state.orderDetails;
    orderDetailsCopy[element.target.name].amount = parseInt(
      element.target.value
    );
    this.setState({orderDetails:orderDetailsCopy});
  }

  placeOrder(){
    const usr_params = queryString.parse(this.props.location.search);
    axios
      .post('/api/orders',
       {'provider':parseInt(usr_params.id),
        'items':this.state.orderDetails,
        'consumer':this.state.consumer}
      ).then((response) =>{
        this.props.history.push("/profile");
      }).catch((error) =>{
        if(error.response.status === 404){
          alert('404');
        } else if(error.response.status === 400){
          alert("400");
        } else {
          alert(error);
        }
      });
  }

  componentDidMount(){

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

    const usr_params = queryString.parse(this.props.location.search);
    var items_array_helper = [];
    axios
      .get('/api/items',{
        params: {
          'provider': usr_params.id
        }
      }).then((response) => {
        for ( var i = 0; i < response.data.length ;i++){
          items_array_helper[i] = {id: response.data[i].id, amount:0};
        };
        this.setState({items:response.data,
                       orderDetails: items_array_helper,
                     });
      }).catch(error => {
        if(error.response.status === 404){
          alert('404');
        } else {
          alert('No estas logeado');
        }
      });
  }
  render() {
    return(
      <div>
        <Navbar logged = {this.state.logged} />
        <OrderForm items={this.state.items}
                orderDetails={this.state.orderDetails}
                onChange ={this.onChange}
                placeOrder = {this.placeOrder}/>
      </div>
    );
  };
}