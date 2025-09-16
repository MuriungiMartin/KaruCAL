#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 61225 "Job Application List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Job Application List.rdlc';

    dataset
    {
        dataitem(UnknownTable61225;UnknownTable61225)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(pics;compinf.Picture)
            {
            }
            column(email;compinf."E-Mail"+';'+compinf."Home Page")
            {
            }
            column(Names;compinf.Name)
            {
            }
            column(Address;compinf.Address+'-'+compinf."Address 2")
            {
            }
            column(Phone1;compinf."Phone No."+';'+compinf."Phone No. 2")
            {
            }
            column(Applic;"HRM-Job Applications (B)"."Application No")
            {
            }
            column(Namez;"HRM-Job Applications (B)"."First Name"+' '+"HRM-Job Applications (B)"."Middle Name"+' '+"HRM-Job Applications (B)"."Last Name")
            {
            }
            column(ApplicEmail;"HRM-Job Applications (B)"."E-Mail")
            {
            }
            column(IdNo;"HRM-Job Applications (B)"."ID Number")
            {
            }
            column(Gender;Format("HRM-Job Applications (B)".Gender))
            {
            }
            column(CellPhone;"HRM-Job Applications (B)"."Cell Phone Number")
            {
            }
            column(seq;seq)
            {
            }
            column(JobDesc;"HRM-Job Applications (B)"."Job Applied for Description")
            {
            }
            column(JobApplied;"HRM-Job Applications (B)"."Job Applied For")
            {
            }

            trigger OnAfterGetRecord()
            begin
                seq:=seq+1;
            end;

            trigger OnPreDataItem()
            begin
                Clear(seq);
                Clear(filters);
                filters:="HRM-Job Applications (B)".GetFilters;
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
        compinf.Reset;
        if compinf.Find('-') then begin
            compinf.CalcFields(Picture);
          end;
    end;

    var
        compinf: Record "Company Information";
        seq: Integer;
        filters: Text[1024];
}

