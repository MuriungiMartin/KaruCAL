#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 79005 "Manage Student Banding"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Funding Band Entries";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Year";"Admission Year")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("HouseHold Percentage";"HouseHold Percentage")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Band Code";"Band Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Change Band To";"Change Band To")
                {
                    ApplicationArea = Basic;
                    TableRelation = "Funding Band Categories"."Band Code";
                    Visible = true;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("NFM Household Statement")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                     Cust.Reset;
                      Cust.SetFilter(Cust."No.","Student No.") ;
                      if Cust.Find('-') then
                      Report.Run(78092,true,true,Cust);
                end;
            }
            action("Banding Report")
            {
                ApplicationArea = Basic;
                RunObject = Report "Household Bands";
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        if UserSetup.Get(UserId) then
          begin

            if UserSetup."Create Fee Band"=false then Error('Please note you do not have the system rights to perform the operation');

            end  else begin
              Error('Please note you do not have the system rights to perform the operation');
              end;
    end;

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then
          begin

            if UserSetup."View Bands"=false then Error('Please note you do not have the system rights to perform the operation');

            end  else begin
              Error('Please note you do not have the system rights to perform the operation');
              end;



    end;

    var
        Cust: Record Customer;
        UserSetup: Record "User Setup";
}

