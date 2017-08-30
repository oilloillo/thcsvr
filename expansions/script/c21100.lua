--苏生
function c21100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE)
	e1:SetTarget(c21100.target)
	e1:SetOperation(c21100.recop)
	c:RegisterEffect(e1)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c21100.tg)
	e4:SetOperation(c21100.operation)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21100,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,21097)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c21100.reccon)
	e2:SetTarget(c21100.rectg)
	e2:SetOperation(c21100.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,21098)
	e3:SetCondition(c21100.reccon2)
	e3:SetTarget(c21100.rectg2)
	e3:SetOperation(c21100.recop)
	c:RegisterEffect(e3)
	if not c21100.global_check then
		c21100.global_check=true
		for i=0,9 do
			c21100[i]=0
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(c21100.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c21100.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c21100.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==Duel.GetTurnPlayer() then
			local val=(ev)
			c21100[ep]=val+c21100[ep]
	end
end
function c21100.clear(e,tp,eg,ep,ev,re,r,rp)
	c21100[2]=c21100[0]
	c21100[3]=c21100[1]
	c21100[4]=c21100[0]
	c21100[5]=c21100[1]
	c21100[6]=c21100[0]
	c21100[7]=c21100[1]
	c21100[8]=c21100[0]
	c21100[9]=c21100[1]
	c21100[Duel.GetTurnPlayer()]=0
end
function c21100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cp=6+tp
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(math.ceil(c21100[cp])/4)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(c21100[cp])/4)
	c21100[cp]=0
end
function c21100.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cp=8+tp
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(math.ceil(c21100[cp])/2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(c21100[cp])/2)
	c21100[cp]=0
end
function c21100.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c21100.filter1(c)
	return c:IsSetCard(0x137) and c:IsType(TYPE_MONSTER)
end
function c21100.filter2(c)
	return c:IsSetCard(0x137) and c:IsFaceup()
end
function c21100.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21100.filter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c21100.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cp=2+tp
	if chk==0 then return c21100[cp]>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(math.ceil(c21100[cp])/2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(c21100[cp])/2)
	c21100[cp]=0
end
function c21100.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c21100.reccon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21100.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c21100.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local cp=4+tp
	if chk==0 then return c21100[cp]>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(math.ceil(c21100[cp])/4)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(c21100[cp]/4))
	c21100[cp]=0
end
