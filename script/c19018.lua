--知识与避世的月兔✿帕秋莉
function c19018.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x255),aux.FilterBoolFunction(Card.IsSetCard,0x811),true)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19018,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,19018)
	e1:SetTarget(c19018.pttg)
	e1:SetOperation(c19018.print)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19018,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c19018.target)
	e2:SetOperation(c19018.operation)
	c:RegisterEffect(e2)
end
c19018.hana_mat={
aux.FilterBoolFunction(Card.IsSetCard,0x255),
aux.FilterBoolFunction(Card.IsSetCard,0x811),
}
function c19018.pttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c19018.print(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local t = {
		[1] = {desc=aux.Stringid(19001,2),code=22131},
		[2] = {desc=aux.Stringid(19001,3),code=22132},
		[3] = {desc=aux.Stringid(19001,4),code=22133},
		[4] = {desc=aux.Stringid(19001,5),code=22134},
		[5] = {desc=aux.Stringid(19001,6),code=22135},
		[6] = {desc=aux.Stringid(19001,7),code=22161},
		[7] = {desc=aux.Stringid(19001,8),code=22162},
		[8] = {desc=aux.Stringid(19001,9),code=22191},
	}
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19001,12))
	local sel=Duel.SelectOption(tp,Nef.unpackOneMember(t, "desc"))+1
	local code=t[sel].code
	local token=Duel.CreateToken(tp,code)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
end
function c19018.filter(c)
	return c:IsFaceup()
end
function c19018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c19018.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19018.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c19018.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c19018.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- local e1=Effect.CreateEffect(e:GetHandler())
		-- e1:SetType(EFFECT_TYPE_SINGLE)
		-- e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		-- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		-- e1:SetCountLimit(1)
		-- e1:SetValue(c19018.valcon)
		-- e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		-- tc:RegisterEffect(e1)

		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
-- function c19018.valcon(e,re,r,rp)
--	 return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
-- end

