#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68079 "HRM-Employee"
{
    Caption = 'Employee Card';
    DelayedInsert = false;
    PageType = Document;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = UnknownTable61118;

    layout
    {
        area(content)
        {
            group(Control206)
            {
                Editable = false;
                field("gOpt Active";"gOpt Active")
                {
                    ApplicationArea = Basic;
                    OptionCaption = 'Show Active Employees,Show Archived Employees,Show All Employees';

                    trigger OnValidate()
                    begin
                        if "gOpt Active" = "gopt active"::All then
                          AllgOptActiveOnValidate;
                        if "gOpt Active" = "gopt active"::Archive then
                          ArchivegOptActiveOnValidate;
                        if "gOpt Active" = "gopt active"::Active then
                          ActivegOptActiveOnValidate;
                    end;
                }
                field("Employee Act. Qty";"Employee Act. Qty")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee Arc. Qty";"Employee Arc. Qty")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee Qty";"Employee Qty")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("General Information")
            {
                Caption = 'General Information';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;
                    Editable = true;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Known As";"Known As")
                {
                    ApplicationArea = Basic;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Passport Number";"Passport Number")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field(Citizenship;Citizenship)
                {
                    ApplicationArea = Basic;
                }
                field(Title;Title)
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address";"Postal Address")
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address2";"Postal Address2")
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address3";"Postal Address3")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code2";"Post Code2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code';
                    LookupPageID = "Post Codes";
                }
                field("Residential Address";"Residential Address")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address2";"Residential Address2")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address3";"Residential Address3")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Personal Details")
            {
                Caption = 'Personal Details';
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field(Religion;Religion)
                {
                    ApplicationArea = Basic;
                }
                field("Ethnic Origin";"Ethnic Origin")
                {
                    ApplicationArea = Basic;
                }
                field(Tribe;Tribe)
                {
                    ApplicationArea = Basic;
                }
                field("First Language (R/W/S)";"First Language (R/W/S)")
                {
                    ApplicationArea = Basic;
                }
                field("Second Language (R/W/S)";"Second Language (R/W/S)")
                {
                    ApplicationArea = Basic;
                }
                field("Additional Language";"Additional Language")
                {
                    ApplicationArea = Basic;
                }
                field("First Language Write";"First Language Write")
                {
                    ApplicationArea = Basic;
                }
                field("Second Language Write";"Second Language Write")
                {
                    ApplicationArea = Basic;
                }
                field("Driving Licence";"Driving Licence")
                {
                    ApplicationArea = Basic;
                }
                field("First Language Speak";"First Language Speak")
                {
                    ApplicationArea = Basic;
                }
                field("Second Language Speak";"Second Language Speak")
                {
                    ApplicationArea = Basic;
                }
                field(Disabled;Disabled)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if Disabled = Disabled::No then
                        begin
                           "Disabling DetailsEditable" := false;
                           "Disability GradeEditable" := false;
                        end
                        else
                           "Disabling DetailsEditable" := true;
                           "Disability GradeEditable" := true;
                    end;
                }
                field("Disabling Details";"Disabling Details")
                {
                    ApplicationArea = Basic;
                    Editable = "Disabling DetailsEditable";
                }
                field("Disability Grade";"Disability Grade")
                {
                    ApplicationArea = Basic;
                    Editable = "Disability GradeEditable";
                }
                field("Health Assesment?";"Health Assesment?")
                {
                    ApplicationArea = Basic;
                    Caption = 'Health Assessment?';
                }
                field("Medical Scheme No.";"Medical Scheme No.")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Scheme Head Member";"Medical Scheme Head Member")
                {
                    ApplicationArea = Basic;
                }
                field("Number Of Dependants";"Number Of Dependants")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Scheme Name";"Medical Scheme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Scheme Name #2";"Medical Scheme Name #2")
                {
                    ApplicationArea = Basic;
                }
                field("Health Assesment Date";"Health Assesment Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Health Assessment Date';
                }
                group("  R      W     S")
                {
                    Caption = '  R      W     S';
                    field("First Language Read";"First Language Read")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Second Language Read";"Second Language Read")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
            group("Important Dates")
            {
                Caption = 'Important Dates';
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(DAge;DAge)
                {
                    ApplicationArea = Basic;
                    Caption = 'Age';
                    Editable = false;
                }
                field("Date Of Join";"Date Of Join")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Of Joining The Company';
                }
                field(DService;DService)
                {
                    ApplicationArea = Basic;
                    Caption = 'Length of Service';
                    Editable = false;
                }
                field("End Of Probation Date";"End Of Probation Date")
                {
                    ApplicationArea = Basic;
                }
                field("Pension Scheme Join";"Pension Scheme Join")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pension Scheme Join Date';
                }
                field(DPension;DPension)
                {
                    ApplicationArea = Basic;
                    Caption = 'Time On Pension Scheme';
                    Editable = false;
                }
                field("Medical Scheme Join";"Medical Scheme Join")
                {
                    ApplicationArea = Basic;
                    Caption = 'Medical Aid Scheme Join Date';
                }
                field(DMedical;DMedical)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Wedding Anniversary";"Wedding Anniversary")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Contact Numbers")
            {
                Caption = 'Contact Numbers';
                field("Home Phone Number";"Home Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Cellular Phone Number";"Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Fax Number";"Fax Number")
                {
                    ApplicationArea = Basic;
                }
                field("Work Phone Number";"Work Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Ext.";"Ext.")
                {
                    ApplicationArea = Basic;
                }
                field("Post Office No";"Post Office No")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Company E-Mail";"Company E-Mail")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Job Information")
            {
                Caption = 'Job Information';
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Position';
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = Basic;
                }
                field("Name Of Manager";"Name Of Manager")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Rec HR Employee": Record UnknownRecord61118;
                    begin
                        /*
                        "Form HR Employee".LOOKUPMODE(TRUE);
                        IF ("Form HR Employee".RUNMODAL = ACTION::LookupOK) THEN
                           "Form HR Employee".GETRECORD("Rec HR Employee");
                        
                        "Name Of Manager" := "Rec HR Employee"."Known As" + ' ' + "Rec HR Employee"."Last Name";
                        "Manager Emp No":="Rec HR Employee"."No.";
                         */

                    end;
                }
                field("Grade Level";"Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field("2nd Skills Category";"2nd Skills Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("3rd Skills Category";"3rd Skills Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Primary Skills Category";"Primary Skills Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            group("Contract Information")
            {
                Caption = 'Contract Information';
                field("Contract Location";"Contract Location")
                {
                    ApplicationArea = Basic;
                    Caption = 'Location';
                }
                field("Full / Part Time";"Full / Part Time")
                {
                    ApplicationArea = Basic;
                }
                field(Permanent;Permanent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Permanent';
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                }
                field("Contract End Date";"Contract End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Notice Period";"Notice Period")
                {
                    ApplicationArea = Basic;
                }
                field("Send Alert to";"Send Alert to")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Payment Information")
            {
                Caption = 'Payment Information';
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Department';
                }
                field("Payroll Departments";"Payroll Departments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Center';
                }
                field("PIN Number";"PIN Number")
                {
                    ApplicationArea = Basic;
                }
                field("NSSF No.";"NSSF No.")
                {
                    ApplicationArea = Basic;
                }
                field("NHIF No.";"NHIF No.")
                {
                    ApplicationArea = Basic;
                }
                field("HELB No";"HELB No")
                {
                    ApplicationArea = Basic;
                }
                field("Co-Operative No";"Co-Operative No")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account Number";"Bank Account Number")
                {
                    ApplicationArea = Basic;
                }
                field("Main Bank";"Main Bank")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Bank";"Branch Bank")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Posting Group';
                }
                field("Payroll Posting Group";"Payroll Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Code";"Payroll Code")
                {
                    ApplicationArea = Basic;
                }
                field("Holiday Days Entitlement";"Holiday Days Entitlement")
                {
                    ApplicationArea = Basic;
                }
                field("Holiday Days Used";"Holiday Days Used")
                {
                    ApplicationArea = Basic;
                }
                field("Hourly Rate";"Hourly Rate")
                {
                    ApplicationArea = Basic;
                }
                field("Daily Rate";"Daily Rate")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Separation)
            {
                Caption = 'Separation';
                field("Contract Type1";"Contract Type")
                {
                    ApplicationArea = Basic;
                }
                field("Contract End Date1";"Contract End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Notice Period1";"Notice Period")
                {
                    ApplicationArea = Basic;
                }
                field("Send Alert to1";"Send Alert to")
                {
                    ApplicationArea = Basic;
                }
                field("Served Notice Period";"Served Notice Period")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Leaving";"Date Of Leaving")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Of Leaving The Company';
                }
                field("Termination Category";"Termination Category")
                {
                    ApplicationArea = Basic;
                    Caption = 'Exit Category';

                    trigger OnValidate()
                    begin
                        if "Termination Category" <> "termination category"::" " then
                        Status:=Status::Disabled;
                    end;
                }
                field("Grounds for Term. Code";"Grounds for Term. Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Grounds for Exit';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Exit Interview Date";"Exit Interview Date")
                {
                    ApplicationArea = Basic;
                }
                field("Exit Interview Done by";"Exit Interview Done by")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Re-Employment In Future";"Allow Re-Employment In Future")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DAge:='';
        DService:='';
        DPension:='';
        DMedical:='';
        
        //Recalculate Important Dates
         /* IF ("Date Of Leaving" = 0D) THEN BEGIN
            IF  ("Date Of Birth" <> 0D) THEN
            DAge:= Dates.DetermineAge("Date Of Birth",TODAY);
            IF  ("Date Of Join" <> 0D) THEN
            DService:= Dates.DetermineAge("Date Of Join",TODAY);
            IF  ("Pension Scheme Join" <> 0D) THEN
            DPension:= Dates.DetermineAge("Pension Scheme Join",TODAY);
            IF  ("Medical Scheme Join" <> 0D) THEN
            DMedical:= Dates.DetermineAge("Medical Scheme Join",TODAY);
            //MODIFY;
          END ELSE BEGIN
            IF  ("Date Of Birth" <> 0D) THEN
            DAge:= Dates.DetermineAge("Date Of Birth","Date Of Leaving");
            IF  ("Date Of Join" <> 0D) THEN
            DService:= Dates.DetermineAge("Date Of Join","Date Of Leaving");
            IF  ("Pension Scheme Join" <> 0D) THEN
            DPension:= Dates.DetermineAge("Pension Scheme Join","Date Of Leaving");
            IF  ("Medical Scheme Join" <> 0D) THEN
            DMedical:= Dates.DetermineAge("Medical Scheme Join","Date Of Leaving");
           // MODIFY;
          END; */

    end;

    trigger OnInit()
    begin
        "Disability GradeEditable" := true;
        "Disabling DetailsEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

          //RESET;
          "gOpt Active":="gopt active"::All;
          //MESSAGE('All employee information must be completed.')
    end;

    trigger OnOpenPage()
    begin
        "gOpt Active":="gopt active"::Active;
        SetCurrentkey("Termination Category");
        "Filter Employees"(0);
        DAge:='';
        DService:='';
        DPension:='';
        DMedical:='';
        
        //Recalculate Important Dates
          /*IF ("Date Of Leaving" = 0D) THEN BEGIN
            IF  ("Date Of Birth" <> 0D) THEN
            DAge:= Dates.DetermineAge("Date Of Birth",TODAY);
            IF  ("Date Of Join" <> 0D) THEN
            DService:= Dates.DetermineAge("Date Of Join",TODAY);
            IF  ("Pension Scheme Join" <> 0D) THEN
            DPension:= Dates.DetermineAge("Pension Scheme Join",TODAY);
            IF  ("Medical Scheme Join" <> 0D) THEN
            DMedical:= Dates.DetermineAge("Medical Scheme Join",TODAY);
            //MODIFY;
          END ELSE BEGIN
            IF  ("Date Of Birth" <> 0D) THEN
            DAge:= Dates.DetermineAge("Date Of Birth","Date Of Leaving");
            IF  ("Date Of Join" <> 0D) THEN
            DService:= Dates.DetermineAge("Date Of Join","Date Of Leaving");
            IF  ("Pension Scheme Join" <> 0D) THEN
            DPension:= Dates.DetermineAge("Pension Scheme Join","Date Of Leaving");
            IF  ("Medical Scheme Join" <> 0D) THEN
            DMedical:= Dates.DetermineAge("Medical Scheme Join","Date Of Leaving");
            //MODIFY;
          END;*/
         //VALIDATE("Contract End Date");

    end;

    var
        Mail: Codeunit Mail;
        PictureExists: Boolean;
        "gOpt Active": Option Active,Archive,All;
        D: Date;
        DAge: Text[100];
        DService: Text[100];
        DPension: Text[100];
        DMedical: Text[100];
        currentmonth: Date;
        [InDataSet]
        "Disabling DetailsEditable": Boolean;
        [InDataSet]
        "Disability GradeEditable": Boolean;


    procedure "Filter Employees"(Type: Option Active,Archive,All)
    begin


          if Type = Type::Active then begin
             Reset;
             SetFilter("Termination Category",'=%1',"termination category"::" ");
            end
           else
         if Type = Type::Archive then begin
             Reset;
             SetFilter("Termination Category",'>%1',"termination category"::" ");
            end
           else
         if Type = Type::All then
            Reset;

         CurrPage.Update(false);
         FilterGroup(20);
    end;

    local procedure ActivegOptActiveOnPush()
    begin
          "Filter Employees"(0); //Active Employees
    end;

    local procedure ArchivegOptActiveOnPush()
    begin
          "Filter Employees"(1); //Archived Employees
    end;

    local procedure AllgOptActiveOnPush()
    begin
          "Filter Employees"(2); //  Show All Employees
    end;

    local procedure ActivegOptActiveOnValidate()
    begin
        ActivegOptActiveOnPush;
    end;

    local procedure ArchivegOptActiveOnValidate()
    begin
        ArchivegOptActiveOnPush;
    end;

    local procedure AllgOptActiveOnValidate()
    begin
        AllgOptActiveOnPush;
    end;


    procedure GetSupervisor(var sUserID: Code[20]) SupervisorName: Text[200]
    var
        UserSetup: Record "User Setup";
        HREmp: Record UnknownRecord61188;
    begin
                                if sUserID<>'' then
                                begin
                                        UserSetup.Reset;
                                        if UserSetup.Get(sUserID) then
                                        begin

                                        SupervisorName:=UserSetup."Approver ID";
                                            if SupervisorName<>'' then begin

                                            HREmp.SetRange(HREmp."User ID",SupervisorName);
                                            if HREmp.Find('-') then
                                            SupervisorName:=HREmp.FullName;

                                            end else begin
                                            SupervisorName:='';
                                            end;


                                        end else begin
                                        Error('User'+' '+ sUserID +' '+ 'does not exist in the user setup table');
                                        SupervisorName:='';
                                        end;
                                  end;
    end;
}

