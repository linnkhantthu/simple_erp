import { useState } from "react"
import formStyles from "../styles/Form.module.css"
import Button from "./Button"
import EmailField from "./EmailField"
import PasswordField from "./PasswordField"
import { useRouter } from 'next/router'

const LoginForm = ({legend}) => {
  const router = useRouter()
  const [message, setMessage] = useState()
  const login = async (event) => {
    event.preventDefault()
    const data = {
      email: event.target.email.value,
      password: event.target.password.value
    }
    const JSONdata = JSON.stringify(data)
    const endpoint = '/api/login'
    const options = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSONdata,
    }
    const res = await fetch(endpoint, options)
    const result = await res.json()
    if(result.status === false){
      setMessage(
        message = result.message
      )
    }
    else{
      router.push('/home')
    }
  }

  return (
    <>
        <div className={formStyles.form_container}>
            <form onSubmit={login} className={formStyles.form}>
                <h3>{legend}</h3>
                <EmailField />
                <PasswordField message={message} />
                <Button text="Login"/>
            </form>
        </div>
    </>
  )
}

export default LoginForm

LoginForm.defaultProps = {
  legend: "Form"
}