import 'package:flutter/material.dart';
import 'package:defer_pointer/defer_pointer.dart';

class HexagonButton extends StatefulWidget {
  final bool showMenu;
  final VoidCallback toggleMenu;

  const HexagonButton({
    Key? key,
    required this.showMenu,
    required this.toggleMenu,
  }) : super(key: key);

  @override
  _HexagonButtonState createState() => _HexagonButtonState();
}

class _HexagonButtonState extends State<HexagonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _animation = Tween<double>(begin: 0.5, end: 0.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      child: GestureDetector(
        onTap: () {
          if (widget.showMenu) {
            widget.toggleMenu();
            _controller.reverse(); // Iniciar animación para revertir a rombo
          } else {
            _controller.forward(); // Iniciar animación para girar a cuadrado
            widget.toggleMenu();
          }
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspectiva cero para evitar distorsiones visuales
                ..rotateZ(_animation.value * 0.5 * 3.14), // Reducir escala a la mitad
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.showMenu ? Color.fromRGBO(229, 171, 255, 1) : Color.fromRGBO(79, 40, 87, 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Icon(Icons.close_rounded, color: Colors.white)
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



class MenuWidget extends StatefulWidget {
  final bool showMenu;

  const MenuWidget({Key? key, required this.showMenu}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
    if (widget.showMenu) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MenuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showMenu) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(0.0, -150 + (100 * (1 - _animation.value))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                createOption("Community", 'create_post'),
                SizedBox(height: 10),
                createOption("Post", 'create_post'),
                SizedBox(height: 10),
                createOption("Quiz", 'create_post'),
              ],
            ),
          ),
        );
      },
    );
  }

  ElevatedButton createOption(String option, String choose_create) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, choose_create);
      },
      child: SizedBox(
        height: 35,
        width: 120,
        child: Center(
          child: Text(option, style: TextStyle(color: Colors.black)),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(229, 171, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
