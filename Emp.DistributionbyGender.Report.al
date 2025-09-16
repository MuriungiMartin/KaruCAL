#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51830 "Emp. Distribution by Gender"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Emp. Distribution by Gender.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            column(ReportForNavId_1000000001; 1000000001)
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
            column(females;Females)
            {
            }
            column(males;males)
            {
            }
            column(gender;"HRM-Employee C".Gender)
            {
            }

            trigger OnAfterGetRecord()
            begin
                seq:=seq+1;
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
          Clear(Females);
          Clear(Females);
          HRMSetup.Reset;
          if HRMSetup.Get() then begin
            HRMSetup.CalcFields("Total Females","Total Males");
            end else Error('HRm Setup does NOT EXISTS!');
    end;

    var
        info: Record "Company Information";
        seq: Integer;
        showdata: Boolean;
        Females: Integer;
        males: Integer;
        HRMSetup: Record UnknownRecord61675;
}

