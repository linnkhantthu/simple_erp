import formStyles from "../styles/Form.module.css"

const PasswordField = ({error_message}) => {
  return (
    <>
        <label htmlFor="Password"><small>Password</small></label>
        <input type="Password" id="Password" className={formStyles.form_input}/>
        <small className={formStyles.error_text}>{error_message}</small>
    </>
  )
}

export default PasswordField