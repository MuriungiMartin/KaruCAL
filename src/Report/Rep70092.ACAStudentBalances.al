#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70092 "ACA-Student Balances"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Student Balances.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code) order(ascending);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1410; 1410)
            {
            }
            column(USERID;UserId)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(Totald;Totald)
            {
            }
            column(totalc;totalc)
            {
            }
            column(totalb;totalb)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CustomerCaption;CustomerCaptionLbl)
            {
            }
            column(Programme_Code;Code)
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = Programme=field(Code);
                DataItemTableView = sorting("Student No.") order(ascending) where(Reversed=const(No),Posted=const(Yes));
                PrintOnlyIfDetail = true;
                RequestFilterFields = Programme,"Settlement Type",Stage,Session,Semester;
                column(ReportForNavId_2901; 2901)
                {
                }
                column(Customer__No__Caption;Customer.FieldCaption("No."))
                {
                }
                column(Customer_NameCaption;Customer.FieldCaption(Name))
                {
                }
                column(Customer__Debit_Amount__LCY__Caption;Customer.FieldCaption("Debit Amount (LCY)"))
                {
                }
                column(Customer__Credit_Amount__LCY__Caption;Customer.FieldCaption("Credit Amount (LCY)"))
                {
                }
                column(Customer__Balance__LCY__Caption;Customer.FieldCaption("Balance (LCY)"))
                {
                }
                column(StageCaption;StageCaptionLbl)
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
                column(Course_Registration_Programmefilter;"ACA-Course Registration"."Programme Filter")
                {
                }
                column(Studentstatus;"ACA-Course Registration"."Student Status")
                {
                }
                column(Settlemnt;"ACA-Course Registration"."Settlement Type")
                {
                }
                column(Course_Registration_Entry_No_;"Entry No.")
                {
                }
                dataitem(Customer;Customer)
                {
                    CalcFields = "Debit Amount","Credit Amount",Balance;
                    DataItemLink = "No."=field("Student No.");
                    DataItemTableView = sorting("No.") order(ascending) where("Customer Type"=const(Student));
                    RequestFilterFields = "No.","Date Filter","Balance (LCY)","Debit Amount (LCY)","Credit Amount (LCY)","Credit Amount";
                    column(ReportForNavId_6836; 6836)
                    {
                    }
                    column(NCount;NCount)
                    {
                    }
                    column(Customer__No__;"No.")
                    {
                    }
                    column(Customer_Name;Name)
                    {
                    }
                    column(Customer__Debit_Amount__LCY__;"Debit Amount (LCY)")
                    {
                    }
                    column(Customer__Credit_Amount__LCY__;"Credit Amount (LCY)")
                    {
                    }
                    column(Customer__Balance__LCY__;"Balance (LCY)")
                    {
                    }
                    column(Hesabu;Hesabu)
                    {
                    }
                    column(Course_Registration__Stage;"ACA-Course Registration".Stage)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                          NCount:=NCount+1;
                         Totald:=Totald+Customer."Debit Amount (LCY)";
                        totalc:=totalc+Customer."Credit Amount (LCY)";
                        totalb:=totalb+Customer."Balance (LCY)";
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SemesterFilter;SemesterFilter)
                {
                    ApplicationArea = Basic;
                    TableRelation = "ACA-Semesters".Code;
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
        Hesabu: Integer;
        totalc: Decimal;
        Totald: Decimal;
        totalb: Decimal;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CustomerCaptionLbl: label 'Customer';
        StageCaptionLbl: label 'Stage';
        NCount: Integer;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        Balance: Decimal;
        Sems: Record UnknownRecord61692;
        SemDate: Date;
        DetailedLedgers: Record "Detailed Cust. Ledg. Entry";
        SemesterFilter: Code[20];
}

