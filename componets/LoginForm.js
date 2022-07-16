import formStyles from "../styles/Form.module.css"
import Button from "./Button"
import EmailField from "./EmailField"
import PasswordField from "./PasswordField"

const LoginForm = ({legend}) => {
  return (
    <>
        <div className={formStyles.form_container}>
            <form className={formStyles.form}>
                <h3>{legend}</h3>

                <EmailField />
                <PasswordField />
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
