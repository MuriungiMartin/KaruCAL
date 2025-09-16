#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78056 "Aca-Results Buffer User Depts"
{
    PageType = List;
    SourceTable = UnknownTable78056;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field(Permissions;Permissions)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Clear(CountedLoops);
                        repeat
                          begin
                        AcaResultsBufferPermissions.Init;
                        AcaResultsBufferPermissions."User ID" := Rec."User ID";
                        AcaResultsBufferPermissions."Department Code" := Rec."Department Code";
                        AcaResultsBufferPermissions."Permission Code" :=CountedLoops;
                        if AcaResultsBufferPermissions.Insert then;
                          CountedLoops := CountedLoops+1;
                          end;
                            until CountedLoops = 7;

                        Clear(AcaResultsBufferPermissions);
                        AcaResultsBufferPermissions.Reset;
                        AcaResultsBufferPermissions.SetRange("User ID",Rec."User ID");
                        AcaResultsBufferPermissions.SetRange("Department Code",Rec."Department Code");
                        if AcaResultsBufferPermissions.Find('-') then begin
                        Page.Run(78057,AcaResultsBufferPermissions);
                          end;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        AcaResultsBufferUserDepts: Record UnknownRecord78056;
        CountedLoops: Integer;
        AcaResultsBufferPermissions: Record UnknownRecord78057;
}

