const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json()); // to support JSON-encoded bodies

const inventory = [
  { id: 1, prodname: "prod1", qty: 12, price: 12 },
  { id: 2, prodname: "prod2", qty: 1, price: 13 },
  { id: 3, prodname: "prod3", qty: 10, price: 14 },
  { id: 4, prodname: "prod4", qty: 19, price: 16 },
];

app.get('/', (req, res) => {
  res.json(inventory);
});

app.post('/add', (req, res) => {
  console.log(req.body);
  const invent = {
    id: req.body.id,
    prodname: req.body.prodname,
    qty: req.body.qty,
    price: req.body.price,
  };
  inventory.push(invent);
  res.json(inventory);
});

app.listen(8000, () => {
  console.log('express is working at http://localhost:8000');
});

import React, { useState, useEffect } from "react";
import axios from "axios";

function Display_Inventory() {
  const [res, setres] = useState([]);

  useEffect(() => {
    const resp = async () => {
      const response = await axios.get("http://localhost:8000");
      console.log("Inventory:", response.data);
      setres(response.data);
    };
    resp();
  }, []);

  return (
    <div>
      <h1>Inventory Management</h1>
      <table border="1">
        <thead>
          <tr>
            <th>ID</th>
            <th>Product Name</th>
            <th>Quantity</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          {res.map((inventory) => (
            <tr key={inventory.id}>
              <td>{inventory.id}</td>
              <td>{inventory.prodname}</td>
              <td>{inventory.qty}</td>
              <td>{inventory.price}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function AddInventory() {
  const [id, setId] = useState(0);
  const [name, setName] = useState("");
  const [qty, setQty] = useState(0);
  const [price, setPrice] = useState(0);
  const [inventory, setInventory] = useState([]);

  const SubmitEvent = () => {
    const fo = { id: Number( id), prodname: name, qty: Number(qty), price: Number(price) };
    console.log("fo", fo);
    const resp = async () => {
      const response = await axios.post("http://localhost:8000/add", fo);
      console.log(response.data);
      const getresponse = await axios.get("http://localhost:8000");
      setInventory(getresponse.data);
    };
    resp();
  };

  return (
    <div>
      <h1>Inventory Management1</h1>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Product Name</th>
            <th>Quantity</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Id</td>
            <td>
              <input type="number" name="id" value={id}
                onChange={(e) => setId(e.target.value)} />
            </td>
          </tr>
          <tr>
            <td>Product Name</td>
            <td>
              <input type="text" name="prodname" value={name}
                onChange={(e) => setName(e.target.value)} />
            </td>
          </tr>
          <tr>
            <td>Quantity</td>
            <td>
              <input type="number" name="qty" value={qty}
                onChange={(e) => setQty(e.target.value)} />
            </td>
          </tr>
          <tr>
            <td>Price</td>
            <td>
              <input type="number" name="price" value={price}
                onChange={(e) => setPrice(e.target.value)} />
            </td>
          </tr>
          <tr>
            <td>
              <input type="submit" name="onSubmit" onClick={SubmitEvent} />
            </td>
          </tr>
        </tbody>
      </table>

      {inventory.length > 0 && (
        <table border="1">
          <tbody>
            {inventory.map((item) => (
              <tr key={item.id}>
                <td>{item.id}</td>
                <td>{item.prodname}</td>
                <td>{item.qty}</td>
                <td>{item.price}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

export { Display_Inventory, AddInventory };
