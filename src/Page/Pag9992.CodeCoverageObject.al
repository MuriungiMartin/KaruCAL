#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9992 "Code Coverage Object"
{
    Caption = 'Objects';
    Editable = false;
    PageType = List;
    SourceTable = "Object";
    SourceTableView = where(Type=filter(<>TableData));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Caption = 'Type';
                }
                field(ID;ID)
                {
                    ApplicationArea = Basic;
                    Caption = 'ID';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                }
                field(Modified;Modified)
                {
                    ApplicationArea = Basic;
                    Caption = 'Modified';
                }
                field(Compiled;Compiled)
                {
                    ApplicationArea = Basic;
                    Caption = 'Compiled';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                }
                field("Version List";"Version List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Version List';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Load)
            {
                ApplicationArea = Basic;
                Caption = 'Load';
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    "Object": Record "Object";
                    CodeCoverageMgt: Codeunit "Code Coverage Mgt.";
                begin
                    Object.CopyFilters(Rec);
                    CodeCoverageMgt.Include(Object);
                end;
            }
        }
    }
}

