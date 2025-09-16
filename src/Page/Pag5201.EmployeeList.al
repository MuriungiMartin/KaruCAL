#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5201 "Employee List"
{
    ApplicationArea = Basic;
    Caption = 'Employee List';
    CardPageID = "Employee Card";
    Editable = false;
    PageType = List;
    SourceTable = Employee;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a number for the employee.';
                }
                field(FullName;FullName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Full Name';
                    ToolTip = 'Specifies the full name of the employee.';
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s first name.';
                    Visible = false;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s middle name.';
                    Visible = false;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s last name.';
                    Visible = false;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s initials.';
                    Visible = false;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s job title.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code.';
                    Visible = false;
                }
                field(Extension;Extension)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s telephone extension.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s telephone number.';
                    Visible = false;
                }
                field("Mobile Phone No.";"Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s mobile telephone number.';
                    Visible = false;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s email address.';
                    Visible = false;
                }
                field("Statistics Group Code";"Statistics Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a statistics group code to assign to the employee for statistical purposes.';
                    Visible = false;
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a resource number for the employee, if the employee is a resource in Resources Planning.';
                    Visible = false;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a search name for the employee.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a comment has been entered for this entry.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name"=const(Employee),
                                  "No."=field("No.");
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=const(5200),
                                      "No."=field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            Employee: Record Employee;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Employee);
                            DefaultDimMultiple.SetMultiEmployee(Employee);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action("&Picture")
                {
                    ApplicationArea = Basic;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No."=field("No.");
                }
                action(AlternativeAddresses)
                {
                    ApplicationArea = Basic;
                    Caption = '&Alternative Addresses';
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No."=field("No.");
                }
                action("Relati&ves")
                {
                    ApplicationArea = Basic;
                    Caption = 'Relati&ves';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No."=field("No.");
                }
                action("Mi&sc. Article Information")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No."=field("No.");
                }
                action("Con&fidential Information")
                {
                    ApplicationArea = Basic;
                    Caption = 'Con&fidential Information';
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No."=field("No.");
                }
                action("Q&ualifications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Q&ualifications';
                    Image = Certificate;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No."=field("No.");
                }
                action("A&bsences")
                {
                    ApplicationArea = Basic;
                    Caption = 'A&bsences';
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No."=field("No.");
                }
                separator(Action51)
                {
                }
                action("Absences b&y Categories")
                {
                    ApplicationArea = Basic;
                    Caption = 'Absences b&y Categories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No."=field("No."),
                                  "Employee No. Filter"=field("No.");
                }
                action("Misc. Articles &Overview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = Page "Misc. Articles Overview";
                }
                action("Confidential Info. Overvie&w")
                {
                    ApplicationArea = Basic;
                    Caption = 'Confidential Info. Overvie&w';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                }
            }
        }
        area(processing)
        {
            action("Absence Registration")
            {
                ApplicationArea = Basic;
                Caption = 'Absence Registration';
                Image = Absence;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Absence Registration";
            }
        }
    }
}

