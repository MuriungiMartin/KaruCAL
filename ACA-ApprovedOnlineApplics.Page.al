#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68833 "ACA-Approved Online Applics"
{
    PageType = Card;
    SourceTable = UnknownTable61647;
    SourceTableView = where(Status=filter(Approved));

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
                field(BankSlipNo;BankSlipNo)
                {
                    ApplicationArea = Basic;
                }
                field(BankSlipDate;BankSlipDate)
                {
                    ApplicationArea = Basic;
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                }
                field("code";code)
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
                field(BankSlipImage;BankSlipImage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Result Slip Scan';
                }
                field("Marketing Strategy";"Marketing Strategy")
                {
                    ApplicationArea = Basic;
                    Caption = 'How you knew the College';
                }
                field("Other Marketing (Specify)";"Other Marketing (Specify)")
                {
                    ApplicationArea = Basic;
                    Caption = 'How you knew us - Others (Specify)';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000023;Notes)
            {
            }
        }
    }

    actions
    {
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

