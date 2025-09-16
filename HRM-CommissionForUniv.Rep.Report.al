#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51805 "HRM-Commission For Univ. Rep."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRM-Commission For Univ. Rep..rdlc';

    dataset
    {
        dataitem(UnknownTable61789;UnknownTable61789)
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_17; 17)
            {
            }
            dataitem(UnknownTable61188;UnknownTable61188)
            {
                DataItemLink = "Salary Category"=field(Code);
                PrintOnlyIfDetail = false;
                column(ReportForNavId_1; 1)
                {
                }
                column(compName;info.Name)
                {
                }
                column(addr;info.Address+', '+info.City)
                {
                }
                column(phone;info."Phone No.")
                {
                }
                column(email;info."E-Mail")
                {
                }
                column(pics;info.Picture)
                {
                }
                column(hrYear;hrYear)
                {
                }
                column(Category;"HRM-Employee Categories".Code)
                {
                }
                column(No;"HRM-Employee C"."No.")
                {
                }
                column(empName;"HRM-Employee C"."First Name"+' '+"HRM-Employee C"."Middle Name"+' '+"HRM-Employee C"."Last Name")
                {
                }
                column(highestQual;qual.Qualification)
                {
                }
                column(Position;"HRM-Employee C"."Job Title")
                {
                }
                column(Age;ages)
                {
                }
                column(Gender;Format("HRM-Employee C".Gender))
                {
                }
                column(Ethnicity;"HRM-Employee C".Tribe)
                {
                }
                column(Disability_Status;"HRM-Employee C"."Physical Disability")
                {
                }
                column(profession;"HRM-Employee C".Profession)
                {
                }
                column(seq;seq)
                {
                }
                column(G_Total;G_Total)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    qual.Reset;
                    qual.SetRange(qual."Employee No.","HRM-Employee C"."No.");
                    qual.SetRange(qual."Highest Qualification",true);
                    if qual.Find('-') then begin

                    end;

                    ages:=dates.DetermineAge_Years("HRM-Employee C"."Date Of Birth",Today);
                    seq:=seq+1;
                    G_Total:=G_Total+1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                      Clear(seq);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Year;hrYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Year';
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

    trigger OnInitReport()
    begin
              info.Reset;
              if info.Find('-') then begin
                info.CalcFields(info.Picture);
              end;
               Clear(G_Total);
    end;

    trigger OnPreReport()
    begin
         if hrYear='' then Error('Please specify the Year first!');
    end;

    var
        info: Record "Company Information";
        DimVal: Record "Dimension Value";
        hrYear: Code[30];
        qual: Record UnknownRecord61827;
        ages: Code[100];
        dates: Codeunit "HR Dates";
        seq: Integer;
        G_Total: Integer;
}

