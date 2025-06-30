import nodemailer from "nodemailer";

export const transporter = nodemailer.createTransport({
    host: 'smtp.sendgrid.net',
    port: 587,
    auth: {
        user: 'apikey',
        pass: process.env.SENDGRID_API_KEY,
    },
});

export async function sendPasswordResetEmail(to: string, resetLink: string) {
    return transporter.sendMail({
        from: `"Aerialib Support" <${process.env.EMAIL_USER}>`,
        to,
        subject: "Password Reset Request",
        html: `<p>Click <a href="${resetLink}">here</a> to reset your password. This link will expire in 15 minutes.</p>`,
    });
}
