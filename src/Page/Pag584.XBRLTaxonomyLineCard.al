#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 584 "XBRL Taxonomy Line Card"
{
    Caption = 'XBRL Taxonomy Line Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "XBRL Taxonomy Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("XBRL Taxonomy Name";"XBRL Taxonomy Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the XBRL taxonomy.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number that is assigned if the taxonomy is imported. This keeps the taxonomy in the same order as the file.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name that was assigned to this line during the import of the taxonomy.';
                }
                field(Label;Label)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the label that was assigned to this line. The label is a user-readable element of the taxonomy.';
                }
                field(Control1020016;Information)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if there is information in the Comment table about this line. The information was imported from the info attribute when the taxonomy was imported.';
                }
                field(Rollup;Rollup)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if there are records in the Rollup Line table about this line. This data was imported when the taxonomy was imported.';
                }
            }
            group("Mapped Data")
            {
                Caption = 'Mapped Data';
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source of the information for this line that you want to export. You can only export one type of information for each line. The Tuple option means that the line represents a number of related lines. The related lines are listed below this line and are indented.';
                }
                field("Constant Amount";"Constant Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that will be exported if the source type is Constant.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the XBRL taxonomy line.';
                }
                field(Control1020020;"G/L Map Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which general ledger accounts will be used to calculate the amount that will be exported for this line.';
                }
                field(Control1020022;Notes)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if there are notes entered in the Comment table about this line element.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&XBRL Line")
            {
                Caption = '&XBRL Line';
                Image = Line;
                separator(Action1020002)
                {
                    Caption = '';
                }
                action(Information)
                {
                    ApplicationArea = Basic;
                    Caption = 'Information';
                    Image = Info;
                    RunObject = Page "XBRL Comment Lines";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No."),
                                  "Comment Type"=const(Information);
                    ToolTip = 'View information in the Comment table about this line. The information was imported from the info attribute when the taxonomy was imported.';
                }
                action(Rollups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rollups';
                    Image = Totals;
                    RunObject = Page "XBRL Rollup Lines";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No.");
                    ToolTip = 'View how XBRL information is rolled up from other lines.';
                }
                action(Notes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Notes';
                    Image = Notes;
                    RunObject = Page "XBRL Comment Lines";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No."),
                                  "Comment Type"=const(Notes);
                    ToolTip = 'View any notes entered in the Comment table about this line element.';
                }
                action("G/L Map Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Map Lines';
                    Image = CompareCOA;
                    RunObject = Page "XBRL G/L Map Lines";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No.");
                    ToolTip = 'View which general ledger accounts will be used to calculate the amount that will be exported for this line.';
                }
            }
        }
    }
}

