#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 9170 "Copy Profile"
{
    Caption = 'Copy Profile';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Profile";"Profile")
        {
            DataItemTableView = sorting("Profile ID");
            column(ReportForNavId_3203; 3203)
            {
            }

            trigger OnAfterGetRecord()
            var
                ConfPersMgt: Codeunit "Conf./Personalization Mgt.";
            begin
                ConfPersMgt.CopyProfile(Profile,NewProfileID);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewProfileID;NewProfileID)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Profile ID';
                        NotBlank = true;
                        ToolTip = 'Specifies the new ID of the profile after copying.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        NewProfileID: Code[30];


    procedure GetProfileID(): Code[30]
    begin
        exit(NewProfileID);
    end;
}

