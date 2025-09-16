#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 119 "User Setup"
{
    ApplicationArea = Basic;
    Caption = 'User Setup';
    PageType = List;
    SourceTable = "User Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a user ID.';
                }
                field("Allow Posting From";"Allow Posting From")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the earliest date on which the user is allowed to post to the company.';
                }
                field("Allow Posting To";"Allow Posting To")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last date on which the user is allowed to post to the company.';
                }
                field("Approver ID";"Approver ID")
                {
                    ApplicationArea = Basic;
                }
                field(Substitute;Substitute)
                {
                    ApplicationArea = Basic;
                }
                field("User Signature";"User Signature")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Use Two Factor Authentication";"Use Two Factor Authentication")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Administrator";"Approval Administrator")
                {
                    ApplicationArea = Basic;
                }
                field(Leave;Leave)
                {
                    ApplicationArea = Basic;
                }
                field("Hostel Admin";"Hostel Admin")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Title";"Approval Title")
                {
                    ApplicationArea = Basic;
                }
                field("Staff No";"Staff No")
                {
                    ApplicationArea = Basic;
                }
                field("Job Tittle";"Job Tittle")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Can Stop Reg.";"Can Stop Reg.")
                {
                    ApplicationArea = Basic;
                }
                field("Can Change Grad. Status";"Can Change Grad. Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Can change Graduation status';
                }
                field("Staff Travel Account";"Staff Travel Account")
                {
                    ApplicationArea = Basic;
                }
                field("Post JVs";"Post JVs")
                {
                    ApplicationArea = Basic;
                }
                field("Post Bank Recs";"Post Bank Recs")
                {
                    ApplicationArea = Basic;
                }
                field("Imprest Account";"Imprest Account")
                {
                    ApplicationArea = Basic;
                }
                field(UserName;UserName)
                {
                    ApplicationArea = Basic;
                }
                field("Create GL";"Create GL")
                {
                    ApplicationArea = Basic;
                }
                field("Create Customer";"Create Customer")
                {
                    ApplicationArea = Basic;
                }
                field("Create Supplier";"Create Supplier")
                {
                    ApplicationArea = Basic;
                }
                field("Create Items";"Create Items")
                {
                    ApplicationArea = Basic;
                }
                field("Create FA";"Create FA")
                {
                    ApplicationArea = Basic;
                }
                field("Create Employee";"Create Employee")
                {
                    ApplicationArea = Basic;
                }
                field("Create Salary";"Create Salary")
                {
                    ApplicationArea = Basic;
                }
                field("Create Course_Reg";"Create Course_Reg")
                {
                    ApplicationArea = Basic;
                }
                field("Create PR Transactions";"Create PR Transactions")
                {
                    ApplicationArea = Basic;
                }
                field("Create Emp. Transactions";"Create Emp. Transactions")
                {
                    ApplicationArea = Basic;
                }
                field("Student Clearance Admin";"Student Clearance Admin")
                {
                    ApplicationArea = Basic;
                }
                field("Is Registrar";"Is Registrar")
                {
                    ApplicationArea = Basic;
                }
                field("Approve Payroll Closure";"Approve Payroll Closure")
                {
                    ApplicationArea = Basic;
                }
                field("Restore Archived Units";"Restore Archived Units")
                {
                    ApplicationArea = Basic;
                }
                field("Can Edit/Merge Units";"Can Edit/Merge Units")
                {
                    ApplicationArea = Basic;
                }
                field("Process Results";"Process Results")
                {
                    ApplicationArea = Basic;
                }
                field("Stopage Reason Setup";"Stopage Reason Setup")
                {
                    ApplicationArea = Basic;
                }
                field("Can Stop Course Reg.";"Can Stop Course Reg.")
                {
                    ApplicationArea = Basic;
                }
                field("Register Time";"Register Time")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether to register the user''s time usage defined as the time spent from when the user logs in to when the user logs out.';
                }
                field("Sales Resp. Ctr. Filter";"Sales Resp. Ctr. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the responsibility center to which you want to assign the user.';
                }
                field("Purchase Resp. Ctr. Filter";"Purchase Resp. Ctr. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the responsibility center to which you want to assign the user.';
                }
                field("Service Resp. Ctr. Filter";"Service Resp. Ctr. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the responsibility center you want to assign to the user. The user will only be able to see service documents for the responsibility center specified in the field. This responsibility center will also be the default responsibility center when the user creates new service documents.';
                }
                field("Time Sheet Admin.";"Time Sheet Admin.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if a user is a time sheet administrator. A time sheet administrator can access any time sheet and then edit, change, or delete it.';
                }
                field("Bulk upload of Units";"Bulk upload of Units")
                {
                    ApplicationArea = Basic;
                }
                field("Can View Sales Reports";"Can View Sales Reports")
                {
                    ApplicationArea = Basic;
                }
                field("Can Update Claims";"Can Update Claims")
                {
                    ApplicationArea = Basic;
                }
                field("Can Exclude Unit from Grad.";"Can Exclude Unit from Grad.")
                {
                    ApplicationArea = Basic;
                }
                field("Can Edit Core Banking";"Can Edit Core Banking")
                {
                    ApplicationArea = Basic;
                }
                field("Cashier Admin";"Cashier Admin")
                {
                    ApplicationArea = Basic;
                }
                field("Can Archive Receipts";"Can Archive Receipts")
                {
                    ApplicationArea = Basic;
                }
                field("Can Archive Prof. Host. Allocs";"Can Archive Prof. Host. Allocs")
                {
                    ApplicationArea = Basic;
                }
                field("Can Archive Results";"Can Archive Results")
                {
                    ApplicationArea = Basic;
                }
                field("Is Cashier";"Is Cashier")
                {
                    ApplicationArea = Basic;
                }
                field(Multilogin;Multilogin)
                {
                    ApplicationArea = Basic;
                }
                field("View Bands";"View Bands")
                {
                    ApplicationArea = Basic;
                }
                field("Sessions Allowed";"Sessions Allowed")
                {
                    ApplicationArea = Basic;
                }
                field("Can Add Stage Semesters";"Can Add Stage Semesters")
                {
                    ApplicationArea = Basic;
                }
                field("Can Modify RFID";"Can Modify RFID")
                {
                    ApplicationArea = Basic;
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
        area(creation)
        {
            action(Imp_Sign)
            {
                ApplicationArea = Basic;
                Caption = 'Import Signature';
                Image = ImportChartOfAccounts;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "APP-User-Setup Signatures";
                RunPageLink = "User ID"=field("User ID");
            }
        }
    }

    trigger OnOpenPage()
    begin
        HideExternalUsers;
    end;
}

