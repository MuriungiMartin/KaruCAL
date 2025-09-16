#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90000 "Object Renumbering"
{
    // http://www.dynamics.is/wp-admin/post.php?post=2064

    Caption = 'Object Renumbering';
    PageType = List;
    SourceTable = UnknownTable90000;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                }
                field("Source ID";"Source ID")
                {
                    ApplicationArea = Basic;
                }
                field("Destination ID";"Destination ID")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Read Object Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Read Object Lines';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    LoadObjectDataIntoSetup;
                end;
            }
            action("Suggest IDs")
            {
                ApplicationArea = Basic;
                Caption = 'Suggest IDs';
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SuggestIDsFromPermissionRange;
                end;
            }
            action("Read from Excel")
            {
                ApplicationArea = Basic;
                Caption = 'Read from Excel';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ImportSetupFromExcel;
                end;
            }
            action("Write to Excel")
            {
                ApplicationArea = Basic;
                Caption = 'Write to Excel';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ExportSetupToExcel;
                end;
            }
            action("Update Object File")
            {
                ApplicationArea = Basic;
                Caption = 'Update Object File';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ReplaceObjectDataContent;
                end;
            }
        }
    }
}

