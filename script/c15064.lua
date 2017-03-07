--魔界旅人✿露西亚
function c15064.initial_effect(c)
	--xyzlv
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c15064.xyzlv)
	c:RegisterEffect(e1)
end
function c15064.xyzlv(e,c,rc)
	return 0x50000+e:GetHandler():GetLevel()
end
