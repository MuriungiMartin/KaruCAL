#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68635 "HMS Dependant Reg Register"
{
    PageType = ListPart;
    SourceTable = UnknownTable61402;
    SourceTableView = where("Patient Type"=const(Employee),
                            Blocked=const(Yes),
                            "Request Registration"=const(Yes),
                            Registered=const(No),
                            Status=const("HOD Medical Approved"));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Registered;Registered)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if Registered=false then
                          begin
                            Blocked:=true;
                          end
                        else
                          begin
                          if Confirm('Register the dependant?')=false then begin exit end;
                            /*Check if the limit for the dependants has been reached*/
                            HMSSetup.Reset;
                            HMSSetup.Get();
                            IntD:=HMSSetup."Limit Of Next Of Kin";
                        
                            Dependant.Reset;
                            Dependant.SetRange(Dependant."Patient Type",Dependant."patient type"::Employee);
                            if Dependant.Find('-') then
                              begin
                                repeat
                                  if Dependant.Blocked=false then
                                    begin
                                      if Dependant."Employee No."="Employee No." then
                                        begin
                                          IntC:=IntC + 1;
                                        end;
                                    end;
                                until Dependant.Next=0;
                              end;
                              IntC:=IntC +1;
                            if IntC>IntD then
                              begin
                                Error('Employee currently has ' +Format( HMSSetup."Limit Of Next Of Kin") + ' dependants. Registration not allowed');
                              end;
                            Blocked:=false;
                          end;
                        Modify;

                    end;
                }
                field("Request Registration";"Request Registration")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Title;Title)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Photo;Photo)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Telephone No. 2";"Telephone No. 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        HMSSetup: Record UnknownRecord61386;
        Dependant: Record UnknownRecord61402;
        IntC: Integer;
        IntD: Integer;
}

