 
--水上爆击机-瑞云
function c50826.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c50826.target)
	e1:SetOperation(c50826.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c50826.eqlimit)
	c:RegisterEffect(e2)
	--confirm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50826,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c50826.cftg1)
	e3:SetOperation(c50826.cfop2)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(50826,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c50826.cftg2)
	e6:SetOperation(c50826.cfop2)
	c:RegisterEffect(e6)
	--dd
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50826,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCondition(c50826.ddcon)
	e4:SetTarget(c50826.thtg)
	e4:SetOperation(c50826.thop)
	c:RegisterEffect(e4)
	--Def up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	e5:SetValue(200)
	c:RegisterEffect(e5)
end
function c50826.eqlimit(e,c)
	return c:IsSetCard(0x64b)
end
function c50826.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x64b)
end
function c50826.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c50826.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50826.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c50826.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c50826.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c50826.cftg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsFacedown() end
	if chk==0 then return e:GetHandler():GetFlagEffect(50826)==0 and Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
	e:GetHandler():RegisterFlagEffect(50826,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c50826.cfop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ConfirmCards(tp,tc)
	end
end
function c50826.cftg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(50826)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=1 end
	Duel.SetTargetPlayer(tp)
	e:GetHandler():RegisterFlagEffect(50826,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c50826.cfop2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetDecktopGroup(1-p,1)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
	end
end
function c50826.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c50826.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c50826.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENCE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
		if tc:GetDefence()==0 then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
