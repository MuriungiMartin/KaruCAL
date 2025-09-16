#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51828 "Employee Distribution by Tribe"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Distribution by Tribe.rdlc';

    dataset
    {
        dataitem(UnknownTable61836;UnknownTable61836)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(TribeCode;Tribes."Tribe Code")
            {
            }
            column(TribeName;Tribes.Description)
            {
            }
            column(TotalEmployees;Tribes."Total Employees")
            {
            }
            column(showdata;showdata)
            {
            }
            column(logo;info.Picture)
            {
            }
            column(CoName;info.Name)
            {
            }
            column(CoAddress;info.Address)
            {
            }
            column(CoCity;info.City)
            {
            }
            column(CoPhone;info."Phone No.")
            {
            }
            column(CoEmail;info."E-Mail")
            {
            }
            column(HomePage;info."Home Page")
            {
            }
            dataitem(UnknownTable61188;UnknownTable61188)
            {
                DataItemLink = Tribe=field("Tribe Code");
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(Pf_No;"HRM-Employee C"."No.")
                {
                }
                column(Title;"HRM-Employee C".Title)
                {
                }
                column(FName;"HRM-Employee C"."First Name")
                {
                }
                column(MName;"HRM-Employee C"."Middle Name")
                {
                }
                column(LName;"HRM-Employee C"."Last Name")
                {
                }
                column(Telephone;"HRM-Employee C"."Cellular Phone Number")
                {
                }
                column(seq;seq)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    seq:=seq+1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(seq);
                Clear(showdata);
                Tribes.CalcFields("Total Employees");
                if Tribes."Total Employees">0 then showdata:=true else showdata:=false;
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
        if info.Get() then begin
            info.CalcFields(info.Picture);
          end;
    end;

    var
        info: Record "Company Information";
        seq: Integer;
        showdata: Boolean;
}

