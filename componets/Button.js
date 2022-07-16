import formStyles from "../styles/Form.module.css"

function Button({type, text}) {
  return (
    <button type={type} className={formStyles.form_button}>{text}</button>
  )
}

export default Button

Button.defaultProps = {
    type: "submit",
    text: "Submit"
}