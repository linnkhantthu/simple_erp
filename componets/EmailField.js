import formStyles from "../styles/Form.module.css"

const EmailField = ({error_message}) => {
  return (
    <>
        <label htmlFor="email"><small>Email</small></label>
        <input type="email" id="email" className={formStyles.form_input}/>
        <small className={formStyles.error_text}>{error_message}</small>
    </>
  )
}

export default EmailField