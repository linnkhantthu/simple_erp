import formStyles from "../styles/Form.module.css"
import Button from "./Button"
import EmailField from "./EmailField"
import PasswordField from "./PasswordField"
import { useRouter } from "next/router"
import { useState } from "react"
import Message from './Message'

const RegisterForm = ({legend}) => {

  const router = useRouter()
  const [message, setMessage] = useState()
  const register = async (event) => {
    event.preventDefault()
    const data = {
      email: event.target.email.value,
      password: event.target.password.value
    }
    const JSONdata = JSON.stringify(data)
    const endpoint = '/api/register'
    const options = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSONdata,
    }
    const res = await fetch(endpoint, options)
    const result = await res.json()
    console.log(result.status)
    if(result.status === false){
      setMessage(
        message = result.message
      )
    }
    else{
      router.push('/')
      setMessage(
        message = result.message
      )
    }
  }

  return (
    <>
        <div className={formStyles.form_container}>
        <Message message={message} category="cyan" />
            <form onSubmit={register} className={formStyles.form}>
                <h3>{legend}</h3>

                <EmailField message={message} />
                <PasswordField />
                <Button text="Register"/>
                
            </form>
        </div>
    </>
  )
}

export default RegisterForm

RegisterForm.defaultProps = {
  legend: "Form"
}
