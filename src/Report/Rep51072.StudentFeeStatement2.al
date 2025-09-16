#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51072 "Student Fee Statement 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Fee Statement 2.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "No.","Date Filter";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudNo;Customer."No.")
            {
            }
            column(StudName;Customer.Name)
            {
            }
            column(Balance;Customer.Balance)
            {
            }
            column(campus;Customer."Global Dimension 1 Code")
            {
            }
            column(ProgName;Progs.Description)
            {
            }
            column(Progs;ACACourseRegistration.Programme)
            {
            }
            column(Semesters;ACACourseRegistration.Semester)
            {
            }
            column(Stages;ACACourseRegistration.Stage)
            {
            }
            column(Settlement;ACACourseRegistration."Settlement Type")
            {
            }
            column(AcadYear;ACACourseRegistration."Academic Year")
            {
            }
            column(compName;CompanyInformation.Name)
            {
            }
            column(address;CompanyInformation.Address+','+CompanyInformation."Address 2")
            {
            }
            column(phones;CompanyInformation."Phone No."+'/'+CompanyInformation."Phone No. 2")
            {
            }
            column(pics;CompanyInformation.Picture)
            {
            }
            column(mails;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            dataitem("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No."=field("No.");
                DataItemTableView = sorting("Customer No.","Posting Date") order(ascending) where("Entry Type"=filter("Initial Entry"));
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(pDate;CustLedgerEntry."Posting Date")
                {
                }
                column(DocNo;CustLedgerEntry."Document No.")
                {
                }
                column(Desc;CopyStr(CustLedgerEntry.Description,1,35)+CustLedgerEntry."External Document No.")
                {
                }
                column(Amount;"Detailed Cust. Ledg. Entry".Amount)
                {
                }
                column(DebitAm;"Detailed Cust. Ledg. Entry"."Debit Amount")
                {
                }
                column(CreditAm;"Detailed Cust. Ledg. Entry"."Credit Amount")
                {
                }
                column(runningBal;runningBal)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //runningBal:=runningBal+"Detailed Cust. Ledg. Entry"."Debit Amount"-"Detailed Cust. Ledg. Entry"."Credit Amount";
                    CustLedgerEntry.Reset;
                    CustLedgerEntry.SetRange(CustLedgerEntry."Entry No.","Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.");
                    if CustLedgerEntry.Find('-') then begin
                      if CustLedgerEntry.Reversed then CurrReport.Skip;
                      end;
                      runningBal:=runningBal+"Detailed Cust. Ledg. Entry".Amount;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(runningBal);
                ACACourseRegistration.Reset;
                ACACourseRegistration.SetRange(ACACourseRegistration."Student No.",Customer."No.");
                ACACourseRegistration.SetFilter(ACACourseRegistration.Programme,'<>%1','');
                ACACourseRegistration.SetFilter(ACACourseRegistration.Reversed,'=%1',false);
                ACACourseRegistration.SetFilter(ACACourseRegistration.Transfered,'=%1',false);
                ACACourseRegistration.SetCurrentkey(Stage);
                if ACACourseRegistration.Find('+') then begin
                  Progs.Reset;
                  Progs.SetRange(Code,ACACourseRegistration.Programme);
                  if Progs.Find('-') then begin
                    end;
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          CompanyInformation.CalcFields(Picture);
          end;
    end;

    var
        runningBal: Decimal;
        ACACourseRegistration: Record UnknownRecord61532;
        Progs: Record UnknownRecord61511;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CompanyInformation: Record "Company Information";
}

