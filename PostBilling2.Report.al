#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51566 "Post Billing2"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = "Student No.",Semester,Stage,Programme;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Bill_StudentsCaption;Bill_StudentsCaptionLbl)
            {
            }
            column(Customer__No__Caption;Customer.FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;Customer.FieldCaption(Name))
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Student_No_;"Student No.")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem(Customer;Customer)
            {
                DataItemLink = "No."=field("Student No.");
                DataItemTableView = sorting("No.") where(Blocked=filter(" "));
                column(ReportForNavId_6836; 6836)
                {
                }
                column(Customer__No__;"No.")
                {
                }
                column(Customer_Name;Name)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    //Billing
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    GenJnl.DeleteAll;



                    GenSetUp.Get();

                    if Charges.Get(ChargeCode) then begin
                    GenJnl.Init;
                    GenJnl."Line No." := GenJnl."Line No." + 10000;
                    GenJnl."Posting Date":=PDate;
                    GenJnl."Document No.":=DocNo;
                    GenJnl.Validate(GenJnl."Document No.");
                    GenJnl."Journal Template Name":='SALES';
                    GenJnl."Journal Batch Name":='STUD PAY';
                    GenJnl."Account Type":=GenJnl."account type"::Customer;
                    //
                    if Cust.Get("No.") then begin
                    if Cust."Bill-to Customer No." <> '' then
                    GenJnl."Account No.":=Cust."Bill-to Customer No."
                    else
                    GenJnl."Account No.":="No.";
                    end;

                    GenJnl.Amount:=ChargeAmount;
                    GenJnl.Validate(GenJnl."Account No.");
                    GenJnl.Validate(GenJnl.Amount);
                    GenJnl.Description:=Charges.Description;
                    GenJnl."Bal. Account Type":=GenJnl."account type"::"G/L Account";
                    GenJnl."Bal. Account No.":=Charges."G/L Account";


                    GenJnl.Validate(GenJnl."Bal. Account No.");
                    GenJnl."Shortcut Dimension 1 Code":=Cust."Global Dimension 1 Code";
                    GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");

                    GenJnl."Shortcut Dimension 2 Code":=Prog."Department Code";
                    GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                    GenJnl."Due Date":=DueDate;
                    GenJnl.Validate(GenJnl."Due Date");
                    if StudentCharges."Recovery Priority" <> 0 then
                    GenJnl."Recovery Priority":=StudentCharges."Recovery Priority"
                    else
                    GenJnl."Recovery Priority":=25;
                    if GenJnl.Amount<>0 then
                    GenJnl.Insert;

                    //Post New
                    GenJnl.Reset;
                    GenJnl.SetRange("Journal Template Name",'SALES');
                    GenJnl.SetRange("Journal Batch Name",'STUD PAY');
                    if GenJnl.Find('-') then begin
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post B",GenJnl);
                    end;

                    //Post New


                    end;


                    //BILLING
                end;
            }

            trigger OnPreDataItem()
            begin
                    if ChargeCode='' then Error('Please select the Charge Code');
                    if ChargeAmount=0 then Error('Please enter the Charge Amount');
                    if PDate=0D then Error('Please enter the Charge Date');
                    if DocNo='' then Error('Please enter the Document No');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ChargeCode;ChargeCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Charge Code';
                    DrillDownPageID = "ACA-Charge";
                    LookupPageID = "ACA-Charge";
                    TableRelation = "ACA-Charge".Code;

                    trigger OnValidate()
                    begin
                            if Charges.Get(ChargeCode) then
                            ChargeAmount:=Charges.Amount;
                    end;
                }
                field(ChargeAmount;ChargeAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount';
                }
                field(PDate;PDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                }
                field(DocNo;DocNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No.';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        StudentPayments: Record UnknownRecord61536;
        StudentCharges: Record UnknownRecord61535;
        GenJnl: Record "Gen. Journal Line";
        Stages: Record UnknownRecord61516;
        Units: Record UnknownRecord61517;
        ExamsByStage: Record UnknownRecord61526;
        ExamsByUnit: Record UnknownRecord61527;
        Charges: Record UnknownRecord61515;
        Receipt: Record UnknownRecord61538;
        ReceiptItems: Record UnknownRecord61539;
        GenSetUp: Record UnknownRecord61534;
        StudentCharges2: Record UnknownRecord61535;
        CourseReg: Record UnknownRecord61532;
        CurrentBill: Decimal;
        GLEntry: Record "G/L Entry";
        CustLed: Record "Cust. Ledger Entry";
        BankLedg: Record "Bank Account Ledger Entry";
        DCustLedg: Record "Detailed Cust. Ledg. Entry";
        PDate: Date;
        DocNo: Code[20];
        VendLedg: Record "Vendor Ledger Entry";
        DVendLedg: Record "Detailed Vendor Ledg. Entry";
        VATEntry: Record "VAT Entry";
        CReg: Record UnknownRecord61532;
        StudCharges: Record UnknownRecord61535;
        CustLed2: Record "Cust. Ledger Entry";
        Receipt2: Record UnknownRecord61538;
        Cont: Boolean;
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        window: Dialog;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Receipts: Record UnknownRecord61538;
        CustLedg: Record "Cust. Ledger Entry";
        DueDate: Date;
        Sems: Record UnknownRecord61692;
        "Settlement Type": Record UnknownRecord61522;
        Prog: Record UnknownRecord61511;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Bill_StudentsCaptionLbl: label 'Bill Students';
        StudHost: Record "ACA-Students Hostel Rooms";
        ChargeCode: Code[20];
        ChargeAmount: Decimal;
}

