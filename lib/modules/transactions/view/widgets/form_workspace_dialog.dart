part of 'package:kassku_mobile/modules/transactions/view/main_screen.dart';

class _FormWorkspaceDialog extends StatelessWidget {
  const _FormWorkspaceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var name = '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buat Area Kerja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Masukan nama area kerja...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
            onChanged: (value) {
              name = value;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (name.isEmpty) {
                  GetIt.I<FlashMessageHelper>().showError(
                    'Area kerja tidak boleh kosong',
                  );
                }

                context.read<WorkspacesBloc>().add(CreateWorkspace(name: name));
                Navigator.pop(context);
              },
              child: const Text('Buat Area Kerja'),
            ),
          ),
        ],
      ),
    );
  }
}
