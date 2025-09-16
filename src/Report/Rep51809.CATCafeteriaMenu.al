#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51809 "CAT-Cafeteria Menu"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CAT-Cafeteria Menu.rdlc';

    dataset
    {
        dataitem(UnknownTable61782;UnknownTable61782)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(pic;info.Picture)
            {
            }
            column(comp;'KARATINA UNIVERSITY')
            {
            }
            column(tittle;'CAFETERIA MENU')
            {
            }
            column(DateFilter;DateFilter)
            {
            }
            column(CafeSections;CafeSections)
            {
            }
            column(seq;seq)
            {
            }
            column(itemCode;"CAT-Cafeteria Item Inventory"."Item No")
            {
            }
            column(Desc;"CAT-Cafeteria Item Inventory"."Item Description")
            {
            }
            column(ItemPrice;"CAT-Cafeteria Item Inventory"."Price Per Item")
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
                 "CAT-Cafeteria Item Inventory".Reset;
                 "CAT-Cafeteria Item Inventory".SetFilter("CAT-Cafeteria Item Inventory"."Menu Date",'=%1',DateFilter);
                 "CAT-Cafeteria Item Inventory".SetFilter("CAT-Cafeteria Item Inventory"."Cafeteria Section",'=%1',CafeSections);
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

