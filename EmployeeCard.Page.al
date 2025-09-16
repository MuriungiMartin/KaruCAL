#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5200 "Employee Card"
{
    Caption = 'Employee Card';
    PageType = Card;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies a number for the employee.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s job title.';
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s first name.';
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s last name.';
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Middle Name/Initials';
                    ToolTip = 'Specifies the employee''s middle name.';
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s initials.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s address.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies another line of the address.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Caption = 'State/ZIP Code';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code.';
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a search name for the employee.';
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s gender.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the last day this entry was modified.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s telephone number.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field(Extension;Extension)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s telephone extension.';
                }
                field("Mobile Phone No.";"Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s mobile telephone number.';
                }
                field(Pager;Pager)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s pager number.';
                }
                field("Phone No.2";"Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s telephone number.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s email address.';
                }
                field("Company E-Mail";"Company E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s email address at the company.';
                }
                field("Alt. Address Code";"Alt. Address Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for an alternate address.';
                }
                field("Alt. Address Start Date";"Alt. Address Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date when the alternate address is valid.';
                }
                field("Alt. Address End Date";"Alt. Address End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last day when the alternate address is valid.';
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                field("Employment Date";"Employment Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the employee began to work for the company.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employment status of the employee.';
                }
                field("Inactive Date";"Inactive Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the employee became inactive, due to disability or maternity leave, for example.';
                }
                field("Cause of Inactivity Code";"Cause of Inactivity Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the cause of inactivity by the employee.';
                }
                field("Termination Date";"Termination Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the employee was terminated, due to retirement or dismissal, for example.';
                }
                field("Grounds for Term. Code";"Grounds for Term. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a termination code for the employee who has been terminated.';
                }
                field("Emplymt. Contract Code";"Emplymt. Contract Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employment contract code for the employee.';
                }
                field("Statistics Group Code";"Statistics Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a statistics group code to assign to the employee for statistical purposes.';
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a resource number for the employee, if the employee is a resource in Resources Planning.';
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a salesperson or purchaser code for the employee, if the employee is a salesperson or purchaser in the company.';
                }
            }
            group(Personal)
            {
                Caption = 'Personal';
                field("Birth Date";"Birth Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s date of birth.';
                }
                field("Social Security No.";"Social Security No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Social Security number of the employee.';
                }
                field("Union Code";"Union Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s labor union membership code.';
                }
                field("Union Membership No.";"Union Membership No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the employee''s labor union membership number.';
                }
            }
        }
        area(factboxes)
        {
            part(Control3;"Employee Picture")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=field("No.");
            }
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
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(5200),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
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
                separator(Action23)
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
                separator(Action61)
                {
                }
                action("Online Map")
                {
                    ApplicationArea = Basic;
                    Caption = 'Online Map';
                    Image = Map;

                    trigger OnAction()
                    begin
                        DisplayMap;
                    end;
                }
            }
        }
    }
}

