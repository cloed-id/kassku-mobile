part of 'package:kassku_mobile/modules/transactions/view/transactions_screen.dart';

class _ListMemberDialog extends StatelessWidget {
  const _ListMemberDialog({
    super.key,
    required this.members,
    required this.workspace,
  });

  final List<MemberWorkspace> members;
  final Workspace workspace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anggota ${workspace.name.capitalizeFirstOfEach}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              final isYou = member.id == workspace.memberWorkspaceId;
              var title = member.username.capitalize;

              if (isYou) {
                title += ' - ( Anda )';
              }

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: ColorName.primary,
                  child: Text(
                    member.username.substring(0, 1).capitalize,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorName.white,
                    ),
                  ),
                ),
                title: Text(title),
                subtitle: Text(member.role.name.capitalize),
                trailing: member.balance != null
                    ? Text(currencyFormatterNoLeading.format(member.balance))
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
