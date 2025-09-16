#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 90020 "FIN-Claims Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FIN-Claims Statement.rdlc';

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            column(ReportForNavId_1000000007; 1000000007)
            {
            }
            column(compname;CompanyInformation.Name)
            {
            }
            column(address;CompanyInformation.Address+' '+CompanyInformation."Address 2")
            {
            }
            column(phones;CompanyInformation."Phone No."+' '+CompanyInformation."Phone No. 2")
            {
            }
            column(mails;CompanyInformation."E-Mail"+' '+CompanyInformation."Home Page")
            {
            }
            column(pic;CompanyInformation.Picture)
            {
            }
            column(VendName;Vendor.Name)
            {
            }
            dataitem(ClaimsLedger;UnknownTable90022)
            {
                CalcFields = "Claim Posted","Is Claim";
                DataItemLink = "Staff No."=field("No.");
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(StaffNo;ClaimsLedger."Staff No.")
                {
                }
                column(TransType;ClaimsLedger."Transaction Type")
                {
                }
                column(DocNo;ClaimsLedger."Document No.")
                {
                }
                column(ClaimCat;ClaimsLedger."Claim Category")
                {
                }
                column(TransDate;ClaimsLedger."Transaction Date")
                {
                }
                column(PriodCode;ClaimsLedger."Period Code")
                {
                }
                column(amount;ClaimsLedger.Amount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ClaimsLedger."Is Claim" then
                        if ClaimsLedger."Claim Posted" = false then CurrReport.Skip;
                end;
            }
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
        Clear(CompanyInformation);
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then
          CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
}

