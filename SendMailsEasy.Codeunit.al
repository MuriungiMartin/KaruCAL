#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 99999 "Send Mails Easy"
{

    trigger OnRun()
    begin
        //GenerateAdmLetter('B100/0029G/19','AdmLetter'+'B1000029G19');
        //GenerateStudentExamCard('A102/0039G/20','SEM1 20/21','');SendEmailEasy_WithAttachment
        // //  SendEmailEasy('Hallo','Wanjala Tinga','We are Simply Testing the Mailing Functionality Here','If you received this, we Love you',
        // //  'System Generated Mails are not to be replied to','Contact 0704121064 for Assistance','wanjalatom2003@gmail.com','AUTOMATIC MAILS TEST');
        // // SendEmailEasy_WithAttachment('Hallo','Wanjala Tinga','We are Simply Testing the Mailing Functionality Here','If you received this, we Love you',
        // // 'System Generated Mails are not to be replied to','Contact 0704121064 for Assistance','wanjalatom2003@gmail.com','AUTOMATIC MAILS TEST',
        // // 'D:\NavInstallationTools.psm1','D:\NavInstallationTools.psm1');
    end;


    procedure SendEmailEasy(Salutation: Text[100];UserFullNames: Text[150];Paragraph1: Text[963];Paragraph2: Text[963];Disclaimer1: Text[369];Disclaimer2: Text[369];EmailID: Text[639];MailSubject: Text[639])
    var
        XmlParameters: Text[1024];
        OStream: OutStream;
        IStream: InStream;
        TempFileName: Text[1024];
        CustTempTable: Record Customer temporary;
        CustomerTable: Record Customer;
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        CF_FTLCustomerInvoice: Report "Customer Statement";
    begin
        SMTPMailSetup.Get;
        SMTPMailSetup.TestField("SMTP Server");
        SMTPMailSetup.TestField("User ID");
        SMTPMailSetup.TestField("SMTP Server Port");
        SMTPMailSetup.TestField("Password Key");

        Clear(SMTPMail);
        SMTPMail.CreateMessage(UserFullNames,SMTPMailSetup."User ID",EmailID,MailSubject,'',true);
        SMTPMail.AppendBody(Salutation+','+UserFullNames+',');

        SMTPMail.AppendBody('<br>');
        SMTPMail.AppendBody(Paragraph1);
        SMTPMail.AppendBody('<br>');
        SMTPMail.AppendBody(Paragraph2);
        SMTPMail.AppendBody('<HR>');
        SMTPMail.AppendBody(Disclaimer1);
        SMTPMail.AppendBody('<br>');
        SMTPMail.AppendBody(Disclaimer2);
        SMTPMail.Send;
    end;


    procedure SendEmailEasy_WithAttachment(Salutation: Text[100];UserFullNames: Text[150];Paragraph1: Text[963];Paragraph2: Text[963];Disclaimer1: Text[369];Disclaimer2: Text[369];EmailID: Text[639];MailSubject: Text[639];Filepaths: Text[250];AttachmentTitle: Code[250])
    var
        XmlParameters: Text[1024];
        OStream: OutStream;
        IStream: InStream;
        TempFileName: Text[1024];
        CustTempTable: Record Customer temporary;
        CustomerTable: Record Customer;
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        ClearanceReport: Report "Clearance Form (Report)";
        filename: Text[250];
    begin
        filename :=Filepaths;
        if not Exists(filename) then
          Error('File not found!');


        SMTPMailSetup.Get;
        SMTPMailSetup.TestField("SMTP Server");
        SMTPMailSetup.TestField("User ID");
        SMTPMailSetup.TestField("SMTP Server Port");
        SMTPMailSetup.TestField("Password Key");

        Clear(SMTPMail);
        SMTPMail.CreateMessage(UserFullNames,SMTPMailSetup."User ID",EmailID,MailSubject,'',true);
         SMTPMail.AddAttachment(AttachmentTitle,filename);
        SMTPMail.AppendBody(Salutation+','+UserFullNames+',');

        SMTPMail.AppendBody('<br>');
        SMTPMail.AppendBody(Paragraph1);
        SMTPMail.AppendBody('<br>');
        SMTPMail.AppendBody(Paragraph2);
        SMTPMail.AppendBody('<HR>');
        SMTPMail.AppendBody(Disclaimer1);
        SMTPMail.AppendBody('<br>');
        SMTPMail.AppendBody(Disclaimer2);
        SMTPMail.Send;
    end;
}

