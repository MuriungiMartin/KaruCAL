#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 61900 "CAT-Sales Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CAT-Sales Register.rdlc';

    dataset
    {
        dataitem(UnknownTable61783;UnknownTable61783)
        {
            DataItemTableView = where(Status=filter(Posted));
            column(ReportForNavId_1; 1)
            {
            }
            column(pic;info.Picture)
            {
            }
            column(comp;'KARATINA UNIVERSITY')
            {
            }
            column(tittle;'RECEIPTS REGISTER')
            {
            }
            column(DateFilter;"CAT-Cafeteria Receipts"."Receipt Date")
            {
            }
            column(CafeSections;"CAT-Cafeteria Receipts".Sections)
            {
            }
            column(seq;seq)
            {
            }
            column(itemCode;"CAT-Cafeteria Receipts"."Receipt No.")
            {
            }
            column(Desc;"CAT-Cafeteria Receipts".User)
            {
            }
            column(ItemPrice;"CAT-Cafeteria Receipts"."Recept Total")
            {
            }
            column(RepStatus;"CAT-Cafeteria Receipts".Status)
            {
            }
            column(warning;'The Cafeteria Management reserves the right to sell an Item on the menu')
            {
            }
            column(bonapettie;'***************************************** BON APETTIE *****************************************')
            {
            }

            trigger OnAfterGetRecord()
            begin
                 seq:=seq+1;
            end;

            trigger OnPreDataItem()
            begin
                 "CAT-Cafeteria Receipts".Reset;
                 "CAT-Cafeteria Receipts".SetFilter("CAT-Cafeteria Receipts"."Receipt Date",'=%1',DateFilter);
                 "CAT-Cafeteria Receipts".SetFilter("CAT-Cafeteria Receipts"."Cafeteria Section",'=%1',CafeSections);
                 "CAT-Cafeteria Receipts".SetRange("CAT-Cafeteria Receipts".Status,"CAT-Cafeteria Receipts".Status::Posted);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Report_Filter)
                {
                    Caption = 'Report Filter';
                    field(DateFilter;DateFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date Filter';
                    }
                    field(CafeSections;CafeSections)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cafe. Sections';
                    }
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
          DateFilter:=Today;
    end;

    trigger OnPreReport()
    begin
          info.Reset;
          if info.Find('-') then begin
          info.CalcFields(info.Picture);
          end;
          Clear(seq);
          if DateFilter = 0D then Error('Please specify a date.');
          if CafeSections = Cafesections::" " then Error('Specify the Cafeteria section!');
    end;

    var
        DateFilter: Date;
        CafeSections: Option " ",Students,Staff;
        info: Record "Company Information";
        seq: Integer;
}

