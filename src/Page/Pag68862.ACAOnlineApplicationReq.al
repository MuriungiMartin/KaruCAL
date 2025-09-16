#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68862 "ACA-Online Application Req."
{
    PageType = Card;
    SourceTable = UnknownTable61647;
    SourceTableView = where(Status=filter(New));

    layout
    {
        area(content)
        {
            group("Application Request")
            {
                field("Applicant Id Number";"Applicant Id Number")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field(Title;Title)
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("National ID";"National ID")
                {
                    ApplicationArea = Basic;
                }
                field(box;box)
                {
                    ApplicationArea = Basic;
                    Caption = 'P.O. Box';
                }
                field(TelNo_1;TelNo_1)
                {
                    ApplicationArea = Basic;
                    Caption = 'Telephone';
                }
                field(TelNo_2;TelNo_2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cell Phone';
                }
                field(email;email)
                {
                    ApplicationArea = Basic;
                    Caption = 'E-Mail';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                }
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme Category';
                }
                field(Programe_Code1;Programe_Code1)
                {
                    ApplicationArea = Basic;
                    Caption = 'Program (Option 1)';
                }
                field("Prog. Entry level";"Prog. Entry level")
                {
                    ApplicationArea = Basic;
                }
                field("Study Mode";"Study Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Number";"Receipt Number")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                }
                field(Town;Town)
                {
                    ApplicationArea = Basic;
                }
                field(Programe_Code2;Programe_Code2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Program (Option 2)';
                }
                field(Intake;Intake)
                {
                    ApplicationArea = Basic;
                }
                field("Date of Birth";"Date of Birth")
                {
                    ApplicationArea = Basic;
                }
                field("Sponsor Name";"Sponsor Name")
                {
                    ApplicationArea = Basic;
                }
                field("Health Insured";"Health Insured")
                {
                    ApplicationArea = Basic;
                }
                field("Insurer Name";"Insurer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Marketing Strategy";"Marketing Strategy")
                {
                    ApplicationArea = Basic;
                    Caption = 'How you knew the College';
                }
                field("Knew us through (Name)";"Knew us through (Name)")
                {
                    ApplicationArea = Basic;
                }
                field("Other Marketing (Specify)";"Other Marketing (Specify)")
                {
                    ApplicationArea = Basic;
                    Caption = 'How you knew us - Others (Specify)';
                }
                field("Approval Comments";"Approval Comments")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Emergency_Contacts)
            {
                Caption = 'Emergency Contacts';
                field("Emergency Contact Name";"Emergency Contact Name")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Contact Tel";"Emergency Contact Tel")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Phone";"Emergency Phone")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Contact Email";"Emergency Contact Email")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Contact Fax";"Emergency Contact Fax")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Contact Relationship";"Emergency Contact Relationship")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Education)
            {
                field("Highest Institution/University";"Highest Institution/University")
                {
                    ApplicationArea = Basic;
                }
                field("Highest Qualification";"Highest Qualification")
                {
                    ApplicationArea = Basic;
                }
            }
            group(EnglishLanguage)
            {
                Caption = 'English language';
                field("Language (1)";"Language (1)")
                {
                    ApplicationArea = Basic;
                }
                field("Language (2)";"Language (2)")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Declaration)
            {
                Caption = 'To The Best of my knowledge, The information in True';
                field("Declaration Name";"Declaration Name")
                {
                    ApplicationArea = Basic;
                }
                field("Declaration Date";"Declaration Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Employment_History)
            {
                Caption = 'Employment History';
                field("Present Employer (Name)";"Present Employer (Name)")
                {
                    ApplicationArea = Basic;
                }
                field("Present Employer (Address)";"Present Employer (Address)")
                {
                    ApplicationArea = Basic;
                }
                field("Present Employer (Telephone)";"Present Employer (Telephone)")
                {
                    ApplicationArea = Basic;
                }
                field("Present Employer (Position)";"Present Employer (Position)")
                {
                    ApplicationArea = Basic;
                }
                field("Present Employer (Email)";"Present Employer (Email)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            Description = 'Approval of Online Applications';
            action("PhD Requirements")
            {
                ApplicationArea = Basic;
                Image = Questionaire;
                Promoted = true;
                RunObject = Page "FIN-Imprests List";
                RunPageLink = "No."=field("Applicant Id Number");
            }
            action(Institutions)
            {
                ApplicationArea = Basic;
                Image = CompanyInformation;
                Promoted = true;
                RunObject = Page "FIN-Interbank Transfer";
                RunPageLink = No=field("Applicant Id Number");
            }
            action("Prof. Qualification")
            {
                ApplicationArea = Basic;
                Image = QualificationOverview;
                Promoted = true;
                RunObject = Page "FIN-Payment Header";
                RunPageLink = "No."=field("Applicant Id Number");
            }
            action("Research Work")
            {
                ApplicationArea = Basic;
                Image = MarketingSetup;
                Promoted = true;
                RunObject = Page "FIN-Payment Lines";
                RunPageLink = No=field("Applicant Id Number");
            }
            action(References)
            {
                ApplicationArea = Basic;
                Image = CustomerContact;
                Promoted = true;
                RunObject = Page "HRM-Advertised Job List";
                RunPageLink = "Job Title"=field("Applicant Id Number");
            }
            action("Send Approval Request")
            {
                ApplicationArea = Basic;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Export F/O Consolidation";
                begin
                    
                     if "Applicant Id Number" = '' then
                      Error('No Applicants selected for Approval');
                    //Release the Application for Approval
                    if AppSetup.Get() then
                    if (Today-"Date of Birth")<(AppcSetup."Minimum Age"*365) then Error('The Minimum Required Age for Admission is '+Format(AppcSetup."Minimum Age")+' years');
                    
                    if Confirm('Send this Application for Approval?',true)=false then exit;
                    
                    //Apps.RESET;
                    //Apps.SETRANGE(Apps."Application No.","Application No.");
                    //Testfields;
                    if "Application Date"=0D then
                      Error('Provide the Application Date First!');
                    //IF "Application Form Receipt No."='' THEN
                     // ERROR('Provide the Bank Slip number.');
                    //WITH Apps DO
                     //   BEGIN
                        // "User ID":=USERID;
                       //  "Date of Receipt":=TODAY;
                        // MODIFY;
                    //END;
                    // ERROR('Niko');
                    // Status:=Status::Approved;
                    // VALIDATE(Status);
                    //MESSAGE('Application Request has been automatically approved and released.');
                    //IF ApprovalMgt.SendOnlineApplicationApprovals(Rec) THEN BEGIN
                    //MESSAGE(FORMAT(xRec.Surname)+' successfully send for Approval');
                    //CurrPage.UPDATE;
                    //END;
                    
                    
                    
                    
                    
                      /*
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    applicformHead.INIT;
                    applicformHead."ID Number":="Applicant Id Number";
                    applicformHead.Surname:=Surname;
                    applicformHead."Other Names":="Other Names";
                    applicformHead."Programme Level":=Level;
                    applicformHead.Nationality:=Nationality;
                    applicformHead."First Degree Choice":=Programe_Code1;
                    applicformHead."Second Degree Choice":=Programe_Code2;
                    applicformHead."Application Date":="Application Date";
                    applicformHead."Telephone No. 1":=TelNo_1;
                    applicformHead."Telephone No. 2":=TelNo_2;
                    applicformHead."Address for Correspondence3":=email;
                    applicformHead."Receipt Slip No.":=BankSlipNo;
                    applicformHead."Date Of Receipt Slip":=BankSlipDate;
                    applicformHead.Gender:=Gender;
                    applicformHead."Address for Correspondence1":=box+'-'+code;
                    applicformHead."Address for Correspondence2":=Town;
                    applicformHead.District:=County;
                    applicformHead."First Choice Semester":=Intake;
                    applicformHead.Password:="Applicant Id Number";
                    applicformHead.INSERT(TRUE);
                    
                    Status:=Status::"Pending Approval";
                    MODIFY;
                    // Notify Applicant
                    MESSAGE('Application request Accepted.');
                      {
                    // Send Email to the Applicant Nitifying them of the Approvals
                    
                    Subject := STRSUBSTNO('ILU Admission Application','Approved Request');
                    Body := 'Your Request for application at ILU has been Approved!';
                    
                    ////SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,TRUE);
                    //Body := '';
                    
                    WHILE InStreamTemplate.EOS() = FALSE DO BEGIN
                      InStreamTemplate.READTEXT(InSReadChar,1);
                      IF InSReadChar = '%' THEN BEGIN
                        //SMTP.AppendBody(Body);
                        Body := InSReadChar;
                        IF InStreamTemplate.READTEXT(InSReadChar,1) <> 0 THEN;
                        IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN BEGIN
                          Body := Body + '1';
                          CharNo := InSReadChar;
                          WHILE (InSReadChar >= '0') AND (InSReadChar <= '9') DO BEGIN
                            IF InStreamTemplate.READTEXT(InSReadChar,1) <> 0 THEN;
                            IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN
                              CharNo := CharNo + InSReadChar;
                          END;
                        END ELSE
                          Body := Body + InSReadChar;
                      //  FillSalesTemplate(Body,CharNo,SalesHeader,ApprovalEntry,0);
                        //SMTP.AppendBody(Body);
                        Body := InSReadChar;
                      END ELSE BEGIN
                        Body := Body + InSReadChar;
                        I := I + 1;
                        IF I = 500 THEN BEGIN
                          //SMTP.AppendBody(Body);
                          Body := '';
                          I := 0;
                        END;
                      END;
                    END;
                    //SMTP.AppendBody(Body);
                    //SMTP.Send;
                     }
                    
                    CurrPage.UPDATE;
                       */

                end;
            }
        }
    }

    var
        applicformHead: Record UnknownRecord61358;
        AppSetup: Record UnknownRecord452;
        SMTP: Codeunit "SMTP Mail";
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[100];
        Subject: Text[100];
        Body: Text[1024];
        InStreamTemplate: InStream;
        InSReadChar: Text[1];
        CharNo: Text[4];
        I: Integer;
        FromUser: Text[100];
        MailCreated: Boolean;
        DegreeName1: Text[200];
        DegreeName2: Text[200];
        FacultyName1: Text[200];
        FacultyName2: Text[200];
        NationalityName: Text[200];
        CountryOfOriginName: Text[200];
        Age: Text[200];
        FormerSchoolName: Text[200];
        CustEntry: Record "Cust. Ledger Entry";
        Apps: Record UnknownRecord61358;
        recProgramme: Record UnknownRecord61511;
        FirstChoiceSemesterName: Text[200];
        FirstChoiceStageName: Text[200];
        SecondChoiceSemesterName: Text[200];
        SecondChoiceStageName: Text[200];
        [InDataSet]
        "Principal PassesVisible": Boolean;
        [InDataSet]
        "Subsidiary PassesVisible": Boolean;
        [InDataSet]
        "Mean Grade AcquiredVisible": Boolean;
        [InDataSet]
        "Points AcquiredVisible": Boolean;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,Admission;
        ApprovalEntries: Page "Approval Entries";
        AppcSetup: Record UnknownRecord61367;
        AdmissionsQualif: Codeunit "Admissions Qualifations";
        EnqH: Record UnknownRecord61348;
}

