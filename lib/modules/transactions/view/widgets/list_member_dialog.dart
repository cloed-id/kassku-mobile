part of 'package:kassku_mobile/modules/transactions/view/main_screen.dart';

class _ListMemberDialog extends StatelessWidget {
  const _ListMemberDialog({
    super.key,
    required this.label,
    required this.members,
    required this.workspace,
    this.ableToSetBalance = false,
  });

  final String label;
  final bool ableToSetBalance;
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
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
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
                onTap: ableToSetBalance
                    ? () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => _SetMemberBalanceDialog(
                            member: member,
                          ),
                        );
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SetMemberBalanceDialog extends StatelessWidget {
  const _SetMemberBalanceDialog({super.key, required this.member});

  final MemberWorkspace member;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set saldo anggota'),
      content: TextField(
        keyboardType: TextInputType.number,
        autofocus: true,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          hintText: 'Saldo',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(color: Colors.black54),
          ),
        ),
        onChanged: (value) {},
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actions: [
        TextButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Simpan'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
